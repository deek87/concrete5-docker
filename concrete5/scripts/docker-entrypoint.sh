#!/bin/sh
set -e

TABLE_EXISTS=$(printf 'SHOW TABLES LIKE "Users"')

_wait_for_mysql(){


until mysql -h "${DATABASE_IP}" -u --C5_DB_USER-- -p--C5_DB_USER_PW-- --C5_DB-- -e 'select 1'; do
  >&2 echo "MySQL is unavailable - sleeping for 1 second"
  echo "Using command : mysql -h "${DATABASE_IP}" -u --C5_DB_USER-- -p--C5_DB_USER_PW-- --C5_DB-- -e 'select 1';"
  sleep 5
done

>&2 echo "Mysql is up - Beginning C5 Check"

_check_setup
}

_install_concrete5() {

    if [ $(mysql -h "${DATABASE_IP}" -u --C5_DB_USER-- -p--C5_DB_USER_PW-- --C5_DB-- -e "$TABLE_EXISTS")  == '' ]; then
        echo $(mysql -h "${DATABASE_IP}" -u --C5_DB_USER-- -p--C5_DB_USER_PW-- --C5_DB-- -e "$TABLE_EXISTS")
        echo "Installing Concrete 5"
        echo "mysql -h "${DATABASE_IP}" -u --C5_DB_USER-- -p--C5_DB_USER_PW-- --C5_DB-- -e '$TABLE_EXISTS'"
        vendor/bin/concrete5 c5:install --db-database="--C5_DB--" --db-password=--C5_DB_USER_PW-- --db-server="${DATABASE_IP}" --db-username="--C5_DB_USER--" --admin-email="--C5_ADMIN_EMAIL--" --admin-password="--C5_ADMIN_PASSWORD--" --ignore-warnings

    else
        vendor/bin/concrete5
        echo "Attaching database"
        vendor/bin/concrete5 c5:install --attach --db-database="--C5_DB--" --db-password=--C5_DB_USER_PW-- --db-server="${DATABASE_IP}" --db-username="--C5_DB_USER--" --admin-email="--C5_ADMIN_EMAIL--" --admin-password="--C5_ADMIN_PASSWORD--" --ignore-warnings || true
        echo "C5 Already Installed"
        vendor/bin/concrete5 c5:is-installed || true
        echo "C5 : Running Update incase"
        vendor/bin/concrete5 c5:update || true
        echo "C5 : Regenerate Proxies"
        vendor/bin/concrete5 orm:generate-proxies

    fi

}
_check_setup() {

    cat /var/www/vhosts/${SITE}/composer.json
    if [ ! -d "/var/www/vhosts/${SITE}/vendor" ]; then

        cd /var/www/vhosts/${SITE}
        echo 'Running Composer Install'
        composer install
        echo 'Begin Concrete5 Install'
        _install_concrete5

    else

        cd /var/www/vhosts/${SITE}
        echo 'Updating Composer'
        composer install || true
        echo 'Updating Concrete5'
         _install_concrete5

    fi

    echo "Restarting php-fpm"
    php-fpm
}


_wait_for_mysql


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"