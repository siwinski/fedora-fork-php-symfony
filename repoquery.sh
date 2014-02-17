#!/bin/bash

SPEC=php-symfony.spec
PKG=`grep '^Name:' ${SPEC} | sed 's/^Name:\s*//'`

#
# Main package
#

echo -e "\033[37;42m>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${PKG}\033[0m"

for REPO_QUERY_TYPE in requires conflicts
do
    echo -e "\033[31m>>>>>>>>>> what${REPO_QUERY_TYPE}\033[0m"

    for REPO_QUERY_PKG in `repoquery --what${REPO_QUERY_TYPE} ${PKG} | grep -v "${PKG}-[0-9]" | sort`
    do
        echo -e "\033[33m$REPO_QUERY_PKG\033[0m";
        repoquery --${REPO_QUERY_TYPE} ${REPO_QUERY_PKG} \
            | grep -i ${PKG} \
            | awk '{print "\t", $0}'
    done
done

read

#
# Sub-packages
#

for SUB_PKG in `grep '^%package' ${SPEC} | sed 's/^%package\s*//'`
do
    FULL_SUB_PKG=${PKG}-${SUB_PKG}
    echo -e "\033[37;42m>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ${FULL_SUB_PKG}\033[0m"

    for REPO_QUERY_TYPE in requires conflicts
    do
        echo -e "\033[31m>>>>>>>>>> what${REPO_QUERY_TYPE}\033[0m"

        for REPO_QUERY_PKG in `repoquery --what${REPO_QUERY_TYPE} ${FULL_SUB_PKG} | grep -v ${FULL_SUB_PKG} | sort`
        do
            echo -e "\033[33m$REPO_QUERY_PKG\033[0m";
            repoquery --${REPO_QUERY_TYPE} ${REPO_QUERY_PKG} \
                | grep -i -e "${PKG}-${SUB_PKG}" -e "php-pear(pear.symfony.com/${SUB_PKG}" \
                | awk '{print "\t", $0}'
        done
    done
    read
done
