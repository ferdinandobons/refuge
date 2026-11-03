// Client minimo dell'API di App Store Connect (Node 18+, nessuna dipendenza).
// Chiave: secrets/apple/asc-api.env (ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_PATH), fuori dal repository.
// Uso, dalla radice del repository:
//   node tool/appstore/asc.mjs status                   app, build e gruppi di TestFlight
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
} else if (cmd === "users") {
  const r = await api("GET", "/v1/users?limit=50");
  for (const u of r.data) console.log(u.attributes.username, u.attributes.roles.join(","));
} else {
  console.log("comandi: status, bundle-id, internal <email>, external <email> [nome]");
}
