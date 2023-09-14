#!/bin/sh

report_type=''
report_filter='.data[].name'
tenancy_id=''
profile_name=''

while getopts 'r:d:t:p:h' opt; do
  case "$opt" in
    r)
      case ${OPTARG} in
        "usage")
          report_type=reports/usage-csv
          ;;
        "cost")
          report_type=reports/cost-csv
          ;;
        *)
          echo 'Error: the allowed values for -r are usage|cost'
          echo 'Usage: $(basename $0) [-r usage|cost ] [-d date] [-t tenancy ocid] [-p profile]'
          exit 1;
          ;;
      esac
      ;;
    d)
      if [[ ${OPTARG} = [0-9][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] || ${OPTARG} = [0-9][0-9][0-9][0-9]-[0-1][0-9] || ${OPTARG} = [0-9][0-9][0-9][0-9] ]]; then
        report_filter='.data[] | select ( .["time-created"] | contains("'"${OPTARG}"'") ) | .name'
      else
        echo 'Error: the date format is incorrect, please use the format YYYY-MM-DD or YYYY-MM or YYYY'
        echo 'Usage: $(basename $0) [-r usage|cost ] [-d date] [-t tenancy ocid] [-p profile]'
        exit 1;
      fi
      ;;
    t)
      tenancy_id=${OPTARG}
      ;;
    p)
      profile_name=${OPTARG}
      ;;
    h)
      echo 'Usage: $(basename $0) [-r usage|cost ] [-d date] [-t tenancy ocid] [-p profile]'
      exit 1
      ;;
    ?)
      echo 'Usage: $(basename $0) [-r usage|cost ] [-d date] [-t tenancy ocid] [-p profile]'
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

declare -a files=(`oci os object list --namespace-name bling --bucket-name $tenancy_id --prefix $report_type --all --profile $profile_name | jq -r "$report_filter"`)

for file in "${files[@]}"
do
  oci os object get --namespace-name bling --bucket-name $tenancy_id --name $file --file ${file#"$report_type/"} --profile $profile_name
done
