# ADR-03: Filter-List and Extension Update Network Paths

> **Status:** Accepted (Recommended)  
> **Date:** 2026-11-04  
> **Author:** Antigravity AI & Maintainer  
> **Deciders:** Project Maintainer  

---

## 1. Context & Problem Statement

Helium Desktop relies on "Helium Services"—a hosted backend that proxies and anonymizes filter-list updates and extension downloads to shield user IP addresses from upstream servers. However, operating a dedicated proxy backend introduces recurring infrastructure costs, bandwidth bottlenecks, and a single point of failure (Risk `R-10`).

We must establish the network update routing for:
1. **uBlock Origin Filter Lists:** Updates for EasyList, EasyPrivacy, uBlock filters, etc.
2. **Extension Updates:** Periodic manifest version checks and CRX downloads from the Chrome Web Store.

---

## 2. Options Considered

### Option 1: Direct Decentralized with Header Anonymization (Recommended)
- Browser fetches filter lists directly from the upstream author repositories (e.g. raw GitHub repositories, AdGuard CDN) and extension updates directly from Google Webstore servers.
- **Privacy Protections:**
  - Strip identifying headers (`X-Client-Data`, Google auth cookies, device serials).
  - Generalize User-Agent string to generic Android Chromium.
  - Distribute fetch requests with randomized jitter to prevent traffic correlation.
- **Pros:** Zero server hosting cost, infinite scalability, zero downtime, decentralized.
- **Cons:** Upstream hosting providers (GitHub, CDN) see user's public IP during list downloads (standard behavior in standard uBO and Firefox).

### Option 2: Project-Hosted Reverse Proxy (Helium Services Model)
- Maintain a dedicated cloud edge server caching filter lists and proxying extension queries.
- **Pros:** Masks user IPs from CDNs.
- **Cons:** High bandwidth costs; if server fails or expires, users cannot update adblock lists; legal liability for proxying traffic.

### Option 3: Partner with Helium Services
- Route mobile traffic through imputnet's existing Helium Services endpoints.
- **Pros:** Zero new server infrastructure needed.
- **Cons:** Unauthorized usage could strain Helium's resources; dependency on an unaffiliated third party.

---

## 3. Decision

We choose **Option 1 (Direct Decentralized with Header Anonymization)** as the default architecture, augmented by user controls:

1. **Header Anonymization:** Every outbound connection for filter lists or extensions is stripped of tracking metadata, unique client tokens, and cookies.
2. **Transparent User Controls:**
   - A dedicated toggle in **Settings > Aether Services > Automatic Filter List Updates** (enabled by default, can be toggled off for complete offline silence).
   - An option for power-users to define a **Custom Proxy URL** if they run their own proxy or Tor/Orbot routing.
3. **Audit Listing:** All target hostnames are registered and justified in `docs/NETWORK_ENDPOINTS.md`.
