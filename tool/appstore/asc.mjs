// Client minimo dell'API di App Store Connect (Node 18+, nessuna dipendenza).
// Chiave: secrets/apple/asc-api.env (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH), fuori dal repository.
// Uso, dalla radice del repository:
//   node tool/appstore/asc.mjs status                   app, build e gruppi di TestFlight
//   node tool/appstore/asc.mjs listing                  versione, categorie, diritti, testi (store/metadata), revisione
//   node tool/appstore/asc.mjs screenshots              immagini iPhone 6,9" da store/screenshots/<lingua>
//   node tool/appstore/asc.mjs attach-build N           la build N nella versione da inviare
//   node tool/appstore/asc.mjs submit                   invia la versione alla revisione di Apple
//   node tool/appstore/asc.mjs users                    utenti del team (i tester interni devono esserlo)
//   node tool/appstore/asc.mjs bundle-id                registra l'ID dell'app (se manca)
//   node tool/appstore/asc.mjs internal <email>         aggiunge un utente del team al gruppo interno
//   node tool/appstore/asc.mjs external <email> [nome]  aggiunge un tester esterno (revisione beta di Apple)
//   node tool/appstore/asc.mjs beta                     testi per i tester, contatto della revisione beta
//                                                    (secrets/apple/review-contact.env), ultima build nei gruppi
//                                                    e, per gli esterni, invio alla revisione beta di Apple
import crypto from "node:crypto";
import fs from "node:fs";
import path from "node:path";

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname), "../..");
export const BUNDLE_ID = "com.ferdinandobonsegna.refuge";

const env = Object.fromEntries(fs.readFileSync(path.join(ROOT, "secrets/apple/asc-api.env"), "utf8")
  .split("\n").filter((l) => l.includes("=")).map((l) => l.split("=").map((s) => s.trim())));
const key = fs.readFileSync(env.ASC_KEY_PATH, "utf8");

function token() {
  const b64 = (o) => Buffer.from(JSON.stringify(o)).toString("base64url");
  const now = Math.floor(Date.now() / 1000);
  const body = `${b64({ alg: "ES256", kid: env.ASC_KEY_ID, typ: "JWT" })}.${b64({
    iss: env.ASC_ISSUER_ID, iat: now, exp: now + 15 * 60, aud: "appstoreconnect-v1" })}`;
  const sig = crypto.sign("sha256", Buffer.from(body), { key, dsaEncoding: "ieee-p1363" });
  return `${body}.${sig.toString("base64url")}`;
}

async function api(method, url, body) {
  const r = await fetch(`https://api.appstoreconnect.apple.com${url}`, {
    method, headers: { Authorization: `Bearer ${token()}`, "Content-Type": "application/json" },
    body: body ? JSON.stringify(body) : undefined });
  const text = await r.text();
  if (!r.ok) throw new Error(`${method} ${url} → ${r.status} ${text.slice(0, 600)}`);
  return text ? JSON.parse(text) : {};
}

async function app() {
  const r = await api("GET", `/v1/apps?filter[bundleId]=${BUNDLE_ID}`);
  if (!r.data.length) throw new Error(`nessuna app con ID ${BUNDLE_ID} in App Store Connect`);
  return r.data[0];
}

async function group(appId, internal) {
  const name = internal ? "Interni" : "Esterni";
  const r = await api("GET", `/v1/apps/${appId}/betaGroups?limit=50`);
  const found = r.data.find((g) => g.attributes.name === name);
  if (found) return found;
  return (await api("POST", "/v1/betaGroups", { data: { type: "betaGroups",
    attributes: { name, isInternalGroup: internal, ...(internal ? { hasAccessToAllBuilds: true } : {}) },
    relationships: { app: { data: { type: "apps", id: appId } } } } })).data;
}

/** La versione dell'App Store ancora modificabile. */
async function version(appId) {
  const v = await api("GET", `/v1/apps/${appId}/appStoreVersions?filter[platform]=IOS&limit=5`);
  const ok = v.data.find((x) => ["PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED",
    "INVALID_BINARY"].includes(x.attributes.appStoreState));
  if (!ok) throw new Error("nessuna versione modificabile");
  return ok;
}

const [cmd, ...args] = process.argv.slice(2);
if (cmd === "bundle-id") {
  const r = await api("GET", `/v1/bundleIds?filter[identifier]=${BUNDLE_ID}`);
  if (r.data.some((b) => b.attributes.identifier === BUNDLE_ID)) console.log("già registrato:", BUNDLE_ID);
  else {
    await api("POST", "/v1/bundleIds", { data: { type: "bundleIds",
      attributes: { identifier: BUNDLE_ID, name: "Refuge", platform: "IOS" } } });
    console.log("registrato:", BUNDLE_ID);
  }
} else if (cmd === "status") {
  const a = await app();
  console.log("app", a.id, a.attributes.name, a.attributes.bundleId);
  const b = await api("GET", `/v1/builds?filter[app]=${a.id}&sort=-uploadedDate&limit=5`);
  for (const x of b.data) console.log("build", x.attributes.version, x.attributes.processingState, x.attributes.uploadedDate);
  const g = await api("GET", `/v1/apps/${a.id}/betaGroups?limit=50`);
  for (const x of g.data) console.log("gruppo", x.attributes.name, x.attributes.isInternalGroup ? "interno" : "esterno");
} else if (cmd === "internal" || cmd === "external") {
  const [email, firstName = ""] = args;
  const a = await app();
  const g = await group(a.id, cmd === "internal");
  await api("POST", "/v1/betaTesters", { data: { type: "betaTesters", attributes: { email, firstName },
    relationships: { betaGroups: { data: [{ type: "betaGroups", id: g.id }] } } } });
  console.log(`${email} nel gruppo ${g.attributes.name}`);
} else if (cmd === "beta") {
  const a = await app();
  const contact = Object.fromEntries(fs.readFileSync(path.join(ROOT, "secrets/apple/review-contact.env"), "utf8")
    .split("\n").filter((l) => l.includes("=")).map((l) => l.split("=").map((s) => s.trim())));
  const description = "Refuge is an offline emergency app for Europe: step-by-step first aid and danger cards, offline maps, "
    + "emergency radio, supplies and a family plan. It works without internet and collects no data.";
  const loc = await api("GET", `/v1/apps/${a.id}/betaAppLocalizations`);
  const attrs = { description, feedbackEmail: contact.REVIEW_CONTACT_EMAIL };
  if (loc.data.length) await api("PATCH", `/v1/betaAppLocalizations/${loc.data[0].id}`, { data: { type: "betaAppLocalizations", id: loc.data[0].id, attributes: attrs } });
  else await api("POST", "/v1/betaAppLocalizations", { data: { type: "betaAppLocalizations", attributes: { locale: "en-GB", ...attrs },
    relationships: { app: { data: { type: "apps", id: a.id } } } } });
  const det = (await api("GET", `/v1/apps/${a.id}/betaAppReviewDetail`)).data;
  await api("PATCH", `/v1/betaAppReviewDetails/${det.id}`, { data: { type: "betaAppReviewDetails", id: det.id, attributes: {
    contactFirstName: contact.REVIEW_FIRST_NAME, contactLastName: contact.REVIEW_LAST_NAME, contactPhone: contact.REVIEW_PHONE,
    contactEmail: contact.REVIEW_CONTACT_EMAIL, demoAccountRequired: false,
    notes: "No account or sign-in. Everything works offline after the first launch; maps and encyclopedias are optional downloads." } } });
  const b = (await api("GET", `/v1/builds?filter[app]=${a.id}&sort=-uploadedDate&limit=1`)).data[0];
  if (!b || b.attributes.processingState !== "VALID") { console.log("build non ancora pronta:", b?.attributes.processingState); process.exit(0); }
  const bl = await api("GET", `/v1/builds/${b.id}/betaBuildLocalizations`);
  const whatsNew = "Try the emergency cards, the Prepare checklist, Supplies, Location and maps (download a country map) and the SOS light.";
  if (!bl.data.length) await api("POST", "/v1/betaBuildLocalizations", { data: { type: "betaBuildLocalizations", attributes: { locale: "en-GB", whatsNew },
    relationships: { build: { data: { type: "builds", id: b.id } } } } });
  for (const internal of [true, false]) {
    const g = await group(a.id, internal);
    if (!internal) await api("POST", `/v1/betaGroups/${g.id}/relationships/builds`, { data: [{ type: "builds", id: b.id }] });
  }
  try {
    await api("POST", "/v1/betaAppReviewSubmissions", { data: { type: "betaAppReviewSubmissions",
      relationships: { build: { data: { type: "builds", id: b.id } } } } });
    console.log(`build ${b.attributes.version} inviata alla revisione beta`);
  } catch (e) { console.log("revisione beta:", e.message.slice(0, 300)); }
} else if (cmd === "listing") {
  const a = await app();
  const META = path.join(ROOT, "store/metadata");
  const field = (loc, f) => { const p = path.join(META, loc, `${f}.txt`); return fs.existsSync(p) ? fs.readFileSync(p, "utf8").trim() : undefined; };
  const locales = fs.readdirSync(META).filter((d) => !d.startsWith("."));
  await api("PATCH", `/v1/apps/${a.id}`, { data: { type: "apps", id: a.id, attributes: { contentRightsDeclaration: "USES_THIRD_PARTY_CONTENT" } } });
  const v = await version(a.id);
  await api("PATCH", `/v1/appStoreVersions/${v.id}`, { data: { type: "appStoreVersions", id: v.id,
    attributes: { versionString: "1.0.0", copyright: `${new Date().getFullYear()} Ferdinando Bonsegna`, releaseType: "MANUAL" } } });
  const info = (await api("GET", `/v1/apps/${a.id}/appInfos`)).data.find((x) => x.attributes.appStoreState !== "READY_FOR_SALE");
  await api("PATCH", `/v1/appInfos/${info.id}`, { data: { type: "appInfos", id: info.id, relationships: {
    primaryCategory: { data: { type: "appCategories", id: "REFERENCE" } },
    secondaryCategory: { data: { type: "appCategories", id: "UTILITIES" } } } } });
  const infoLocs = (await api("GET", `/v1/appInfos/${info.id}/appInfoLocalizations`)).data;
  for (const loc of locales) {
    const ia = { name: field(loc, "name"), subtitle: field(loc, "subtitle"), privacyPolicyUrl: field(loc, "privacy_url") };
    const il = infoLocs.find((x) => x.attributes.locale === loc);
    if (il) await api("PATCH", `/v1/appInfoLocalizations/${il.id}`, { data: { type: "appInfoLocalizations", id: il.id, attributes: ia } });
    else await api("POST", "/v1/appInfoLocalizations", { data: { type: "appInfoLocalizations", attributes: { locale: loc, ...ia },
      relationships: { appInfo: { data: { type: "appInfos", id: info.id } } } } });
    const va = { description: field(loc, "description"), keywords: field(loc, "keywords"),
      promotionalText: field(loc, "promotional_text"), supportUrl: field(loc, "support_url"), marketingUrl: field(loc, "marketing_url") };
    const vl = (await api("GET", `/v1/appStoreVersions/${v.id}/appStoreVersionLocalizations`)).data.find((x) => x.attributes.locale === loc);
    if (vl) await api("PATCH", `/v1/appStoreVersionLocalizations/${vl.id}`, { data: { type: "appStoreVersionLocalizations", id: vl.id, attributes: va } });
    else await api("POST", "/v1/appStoreVersionLocalizations", { data: { type: "appStoreVersionLocalizations", attributes: { locale: loc, ...va },
      relationships: { appStoreVersion: { data: { type: "appStoreVersions", id: v.id } } } } });
    console.log("testi", loc, "ok");
  }
  const c = Object.fromEntries(fs.readFileSync(path.join(ROOT, "secrets/apple/review-contact.env"), "utf8")
    .split("\n").filter((l) => l.includes("=")).map((l) => l.split("=").map((x) => x.trim())));
  const ra = { contactFirstName: c.REVIEW_FIRST_NAME, contactLastName: c.REVIEW_LAST_NAME, contactPhone: c.REVIEW_PHONE,
    contactEmail: c.REVIEW_CONTACT_EMAIL, demoAccountRequired: false,
    notes: fs.readFileSync(path.join(ROOT, "store/review/notes.txt"), "utf8").trim() };
  let d = null;
  try { d = (await api("GET", `/v1/appStoreVersions/${v.id}/appStoreReviewDetail`)).data; } catch { d = null; }
  if (d) await api("PATCH", `/v1/appStoreReviewDetails/${d.id}`, { data: { type: "appStoreReviewDetails", id: d.id, attributes: ra } });
  else await api("POST", "/v1/appStoreReviewDetails", { data: { type: "appStoreReviewDetails", attributes: ra,
    relationships: { appStoreVersion: { data: { type: "appStoreVersions", id: v.id } } } } });
  console.log("versione 1.0.0, categorie Consultazione e Utility, contenuti di terzi, note per la revisione: ok");
} else if (cmd === "screenshots") {
  const a = await app();
  const v = await version(a.id);
  const DISPLAY = "APP_IPHONE_67";
  const verLocs = (await api("GET", `/v1/appStoreVersions/${v.id}/appStoreVersionLocalizations`)).data;
  for (const loc of fs.readdirSync(path.join(ROOT, "store/screenshots")).filter((d) => !d.startsWith("raw") && !d.startsWith("."))) {
    const vl = verLocs.find((x) => x.attributes.locale === loc);
    if (!vl) { console.log("salto", loc); continue; }
    let set = (await api("GET", `/v1/appStoreVersionLocalizations/${vl.id}/appScreenshotSets`)).data.find((x) => x.attributes.screenshotDisplayType === DISPLAY);
    if (set) for (const x of (await api("GET", `/v1/appScreenshotSets/${set.id}/appScreenshots`)).data) await api("DELETE", `/v1/appScreenshots/${x.id}`);
    else set = (await api("POST", "/v1/appScreenshotSets", { data: { type: "appScreenshotSets", attributes: { screenshotDisplayType: DISPLAY },
      relationships: { appStoreVersionLocalization: { data: { type: "appStoreVersionLocalizations", id: vl.id } } } } })).data;
    const dir = path.join(ROOT, "store/screenshots", loc);
    const files = fs.readdirSync(dir).filter((f) => f.endsWith(".png")).sort();
    for (const f of files) {
      const buf = fs.readFileSync(path.join(dir, f));
      const r = await api("POST", "/v1/appScreenshots", { data: { type: "appScreenshots", attributes: { fileName: f, fileSize: buf.length },
        relationships: { appScreenshotSet: { data: { type: "appScreenshotSets", id: set.id } } } } });
      for (const op of r.data.attributes.uploadOperations) {
        const u = await fetch(op.url, { method: op.method, headers: Object.fromEntries(op.requestHeaders.map((h) => [h.name, h.value])),
          body: buf.subarray(op.offset, op.offset + op.length) });
        if (!u.ok) throw new Error(`upload ${f} ${u.status}`);
      }
      await api("PATCH", `/v1/appScreenshots/${r.data.id}`, { data: { type: "appScreenshots", id: r.data.id,
        attributes: { uploaded: true, sourceFileChecksum: crypto.createHash("md5").update(buf).digest("hex") } } });
    }
    console.log("screenshot", loc, files.length);
  }
} else if (cmd === "attach-build") {
  const a = await app();
  const v = await version(a.id);
  const b = (await api("GET", `/v1/builds?filter[app]=${a.id}&filter[version]=${args[0]}`)).data[0];
  if (!b || b.attributes.processingState !== "VALID") throw new Error(`build ${args[0]} non pronta: ${b?.attributes.processingState ?? "assente"}`);
  await api("PATCH", `/v1/appStoreVersions/${v.id}/relationships/build`, { data: { type: "builds", id: b.id } });
  console.log("versione", v.attributes.versionString, "→ build", args[0]);
} else if (cmd === "age") {
  // Età: risposte in store/age-rating.json (le domande di oggi si vedono con "age show").
  const a = await app();
  const info = (await api("GET", `/v1/apps/${a.id}/appInfos`)).data.find((x) => x.attributes.appStoreState !== "READY_FOR_SALE");
  const ar = (await api("GET", `/v1/appInfos/${info.id}/ageRatingDeclaration`)).data;
  if (args[0] === "show") console.log(JSON.stringify(ar.attributes, null, 1));
  else {
    const attributes = JSON.parse(fs.readFileSync(path.join(ROOT, "store/age-rating.json"), "utf8"));
    await api("PATCH", `/v1/ageRatingDeclarations/${ar.id}`, { data: { type: "ageRatingDeclarations", id: ar.id, attributes } });
    console.log("età consigliata salvata");
  }
} else if (cmd === "submit") {
  const a = await app();
  const v = await version(a.id);
  const sub = (await api("POST", "/v1/reviewSubmissions", { data: { type: "reviewSubmissions", attributes: { platform: "IOS" },
    relationships: { app: { data: { type: "apps", id: a.id } } } } })).data;
  await api("POST", "/v1/reviewSubmissionItems", { data: { type: "reviewSubmissionItems",
    relationships: { reviewSubmission: { data: { type: "reviewSubmissions", id: sub.id } },
      appStoreVersion: { data: { type: "appStoreVersions", id: v.id } } } } });
  const done = (await api("PATCH", `/v1/reviewSubmissions/${sub.id}`, { data: { type: "reviewSubmissions", id: sub.id,
    attributes: { submitted: true } } })).data;
  console.log("versione", v.attributes.versionString, "inviata alla revisione:", done.attributes.state);
} else if (cmd === "beta-status") {
  const a = await app();
  const b = await api("GET", `/v1/builds?filter[app]=${a.id}&sort=-uploadedDate&limit=5&include=buildBetaDetail,betaAppReviewSubmission`);
  for (const x of b.data) {
    const det = b.included?.find((i) => i.type === "buildBetaDetails" && i.id === x.relationships.buildBetaDetail.data?.id);
    const rev = b.included?.find((i) => i.type === "betaAppReviewSubmissions" && i.id === x.relationships.betaAppReviewSubmission.data?.id);
    console.log("build", x.attributes.version, "esterni:", det?.attributes.externalBuildState, "revisione beta:", rev?.attributes.betaReviewState ?? "-");
  }
  const g = (await api("GET", `/v1/apps/${a.id}/betaGroups?limit=50`)).data.find((x) => x.attributes.name === "Esterni");
  const t = await api("GET", `/v1/betaGroups/${g.id}/betaTesters`);
  for (const x of t.data) console.log("tester", x.attributes.email, x.attributes.state);
} else if (cmd === "store-status") {
  const a = await app();
  const v = await api("GET", `/v1/apps/${a.id}/appStoreVersions?filter[platform]=IOS&limit=5`);
  for (const x of v.data) console.log("versione", x.attributes.versionString, x.attributes.appStoreState, x.attributes.appVersionState ?? "");
  const r = await api("GET", `/v1/reviewSubmissions?filter[app]=${a.id}&limit=5`);
  for (const x of r.data) console.log("invio", x.attributes.state, x.attributes.submittedDate ?? "");
} else if (cmd === "users") {
  const r = await api("GET", "/v1/users?limit=50");
  for (const u of r.data) console.log(u.attributes.username, u.attributes.roles.join(","));
} else {
  console.log("comandi: status, bundle-id, internal <email>, external <email> [nome]");
}
