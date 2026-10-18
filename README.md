# HELIOZ CLOTHING — React e-commerce starter

## Run locally
1. Install Node.js 20+.
2. Extract this folder, then run `npm install`.
3. Copy `.env.example` to `.env` and set your Supabase project URL and publishable/anon key.
4. In Supabase SQL Editor, run `supabase/schema.sql`.
5. In Supabase Authentication, create the owner's user account. Before launch, follow the SQL security TODO and restrict writes to an explicit admin allowlist.
6. Run `npm run dev`.

## Pages
- `/` Home and collection
- `/shop` Product grid
- `/product/:id` Product details and WhatsApp order request
- `/custom` Custom/bulk inquiry
- `/admin` Owner product management

## Important setup notes
- WhatsApp messages are prefilled only; customers must press Send. Opening WhatsApp does not confirm an order.
- Product stock is not decremented by this starter.
- With Supabase configured, products persist in the database and images in Storage.
- Without Supabase, the shop uses browser localStorage for local preview only. Secure admin login and cloud persistence require Supabase configuration.
- The storage display is an estimate, not a hard 5 GB enforcement mechanism. Supabase plan quotas and project-level usage limits must be configured separately; a client-side counter cannot guarantee a quota.
- The SQL file includes starter authenticated write policies for testing. Do not publish until you replace them with the admin allowlist policy described in the SQL comments.
- Admin image deletion from Storage is not automated in this starter; remove unused files from the bucket or add a server-side cleanup workflow.
- Product images are owner uploads only. No stock/lifestyle photos are included.
