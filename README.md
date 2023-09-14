# oci_usage_cost_reports
A shell script to download the usage and costs reports from OCI tenancy
Developed and tested on Mac, it should work also on Linux and hopefully on Windows Linux Subsystem (not tested)

### Prerequisites
- Install jq from https://jqlang.github.io/jq/download/
- oci-cli installed and configured (https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
- OCI policies to access to the reports (https://docs.oracle.com/en-us/iaas/Content/Billing/Concepts/usagereportsoverview.htm)
- Copy the script oci_reports_download.sh into a directory of your choice, ideally in your path
- Make the script oci_reports_download.sh executable with the command `chmod +x oci_reports_download.sh`

### Usage
`oci_reports_download.sh -r [usage | cost] -p [OCI profile configured in ~/.oci/config] -t [tenancy ocid] -d [date with format YYYY or YYYY-MM or YYYY-MM-DD]`

Date formats:
- YYYY: all the files for the specified year
- YYYY-MM: all the files for the specified month
- YYYY-MM-DD: all the files for the specified day
- If the argument -d is not specified the script will download all the available files in the usage or cost pools
