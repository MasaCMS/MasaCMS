#!/bin/bash
set -e
cd $APP_DIR

# CFConfig Available Password Keys
CFCONFIG_PASSWORD_KEYS=( "adminPassword" "adminPasswordDefault" "hspw" "pw" "defaultHspw" "defaultPw" "ACF11Password" )
ADMIN_PASSWORD_SET=false

# Check for a defined server home directory in box.json
if [[ -f server.json ]]; then

	if [[ ! $SERVER_HOME_DIRECTORY ]]; then
		SERVER_HOME_DIRECTORY=$(cat server.json | jq -r '.app.serverHomeDirectory')
	fi

	if [[ ! $CFENGINE ]]; then
		CFENGINE=$(cat server.json | jq -r '.app.cfengine')
	fi

	# ensure our string nulls are true nulls
	if [[ $SERVER_HOME_DIRECTORY = 'null' ]] || [[ ! $SERVER_HOME_DIRECTORY ]] ; then
		SERVER_HOME_DIRECTORY=''
	else
		echo "Server Home Directory defined in server.json as: ${SERVER_HOME_DIRECTORY}"
		#Assume our admin password has been set if we are including a custom server home
		ADMIN_PASSWORD_SET=true
	fi

	if [[ $CFENGINE = 'null' ]] || [[ ! $CFENGINE ]]; then
		CFENGINE=''
	else
		echo "CF Engine defined as ${CFENGINE}"
	fi

fi

# Default values for engine and home directory - so we can use cfconfig
SERVER_HOME_DIRECTORY="${SERVER_HOME_DIRECTORY:=${HOME}/serverHome}"
CFENGINE="${CFENGINE:=lucee@4.5}"
FULL_VERSION=${CFENGINE#*@*}
ENGINE_VERSION=${FULL_VERSION%%.*}
ENGINE_VENDOR=${CFENGINE%%@*}

echo "Server Home Directory set to: ${SERVER_HOME_DIRECTORY}"
echo "CF Engine set to ${CFENGINE}"
echo "Engine vendor: ${ENGINE_VENDOR}"
echo "Engine version: ${ENGINE_VERSION}"

#Lucee has a different syntax than ACF, since there are two passwords
if [[ $ENGINE_VENDOR == 'lucee' ]]; then
	# Custom format name required by cfconfig ( JIRA:CFCONFIG-1 )
	CFCONFIG_FORMAT="${ENGINE_VENDOR}Server@${ENGINE_VERSION}"
	WEB_CONFIG_FORMAT="${ENGINE_VENDOR}Web@${ENGINE_VERSION}"
	LUCEE_WEB_HOME="${LUCEE_WEB_HOME:-${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-web}"
	echo "Lucee web home set to: ${LUCEE_WEB_HOME}"
	LUCEE_SERVER_HOME="${LUCEE_SERVER_HOME:-${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-server}"
	echo "Lucee server home set to: ${LUCEE_SERVER_HOME}"
else
	CFCONFIG_FORMAT="${ENGINE_VENDOR}@${ENGINE_VERSION}"
fi


#Check for cfconfig specific environment variables
while IFS='=' read -r name value ; do
	if [[ $name == *'cfconfig_'* ]]; then
		prefix=${name%%_*}
		settingName=${name#*_}

		#if our setting is for the admin password, flag it as set
		if [[ " ${CFCONFIG_PASSWORD_KEYS[@]} " =~ " ${settingName} " ]]; then
			ADMIN_PASSWORD_SET=true
		fi

		echo "Setting cfconfig variable ${settingName}"

		if [[ $ENGINE_VENDOR == 'lucee' ]]; then

			box cfconfig set ${settingName}=${value} to=${LUCEE_SERVER_HOME} toFormat=${CFCONFIG_FORMAT} >> /dev/null
			box cfconfig set ${settingName}=${value} to=${LUCEE_WEB_HOME} toFormat=${WEB_CONFIG_FORMAT} >> /dev/null

		else

			box cfconfig set ${settingName}=${value} to=${SERVER_HOME_DIRECTORY}/WEB-INF/cfusion toFormat=${CFCONFIG_FORMAT} >> /dev/null

		fi
	fi
done < <(env)

# Convention environment variable for CFConfig file
if [[ $CFCONFIG ]] && [[ -f $CFCONFIG ]]; then
	echo "Engine configuration file detected at ${CFCONFIG}"

	#if our admin password is provided, flag it as set
	for pwKey in "${CFCONFIG_PASSWORD_KEYS[@]}"
	do
		if [[ $( key=".${pwKey}"; cat ${CFCONFIG} | jq -r "${key}") != 'null' ]]; then
			ADMIN_PASSWORD_SET=true
			break
		fi
	done

	if [[ $ENGINE_VENDOR == 'lucee' ]]; then

		box cfconfig import from=${CFCONFIG} to=${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-server toFormat=${CFCONFIG_FORMAT}

		SERVER_ADMIN_PASSWORD=$(cat ${CFCONFIG} | jq -r '.adminPassword')

		# if our admin password is set, set the web context password as well
		if [[ $SERVER_ADMIN_PASSWORD != 'null' ]] && [[ $(cat ${CFCONFIG} | jq -r '.adminDefaultPassword') == 'null' ]]; then
			echo "Setting Lucee web administrator password to the same value as the server password, since no additional default was detected"
			box cfconfig set adminPassword=${ADMIN_PASSWORD_SET} to=${SERVER_HOME_DIRECTORY}/WEB-INF/lucee-web toFormat=${WEB_CONFIG_FORMAT} >> /dev/null
		fi

	else

		box cfconfig import from=${CFCONFIG} to=${SERVER_HOME_DIRECTORY}/WEB-INF/cfusion toFormat=${CFCONFIG_FORMAT}

	fi

fi

# If our admin password was not provided send a warning.
# We can't set it, because a custom server home may be provided
if [[ ! $ADMIN_PASSWORD_SET ]] || [[ $ADMIN_PASSWORD_SET == 'null' ]]; then

	echo "No admin password was provided in the environment variables.  If you do not have a custom server home directory in your app, your server is insecure!"

fi

if [[ $BOX_INSTALL ]] || [[ $box_install ]]; then
	box install
fi

# We need to do this all on one line because escaped line breaks
# aren't picked up correctly by CommandBox on this base image ( JIRA:COMMANDBOX-598 )
box server set app.cfengine=${CFENGINE} app.serverHomeDirectory=${SERVER_HOME_DIRECTORY} web.host=0.0.0.0 openbrowser=false web.http.port=${PORT} web.ssl.port=${SSL_PORT} web.rewrites.enable=true
box server start

#Sleep for ACF servers
sleep 10

echo "Initializing Mura..."

curl -s --location "http://localhost:8080" > /dev/null

echo "Applying updates..."

curl -s --location "http://localhost:8080?appreload&applydbupdates" > /dev/null

# Skip our tail output when running our tests
if [[ ! $IMAGE_TESTING_IN_PROGRESS ]]; then
	tail -f $( echo $(box server info property=consoleLogPath) | xargs )
fi
