# 1. Identity & Login
az login --use-device-code

# 2. Storage Account Creation (GPv2)
az storage account create --name <name> --resource-group <rg> --kind StorageV2 --access-tier Hot

# 3. File Share Lifecycle
az storage share create --name <share-name> --account-name <account>
az storage share snapshot --name <share-name> --account-name <account>

# 4. Data Protection
az storage account file-service-properties update --enable-delete-retention true --delete-retention-days 7

# 5. Snapshot creation
az storage share snapshot --account-name <account> --name <share-name>

# 6. Idempotency Strategy: Implemented a "Check-Before-Create" logic using az storage account list and az storage share exists. This prevents the script from failing on subsequent runs and ensures the environment remains stable.

# 7. Cost Optimization:

Tier Selection: Chose Hot Tier over Cool. While Cool has lower storage costs, it carries a 30-day minimum billing penalty. Since this is a lab environment for short-term validation, Hot Tier is more cost-effective.

Transactional Awareness: Transaction-optimized tiers were avoided as the workload (single file upload) does not justify the higher storage cost.

Data Integrity: Enabled Soft Delete and initial share snapshots to demonstrate a production-ready approach to accidental data loss and versioning.