#!/bin/sh

BETAPASSWORDPARAM=""
if [ -n "${STEAMBETAPASSWORD}" ]; then
	BETAPASSWORDPARAM="-betapassword ${STEAMBETAPASSWORD}"
fi

bash "${STEAMCMDDIR}/steamcmd.sh" \
	+@sSteamCmdForcePlatformType windows \
	+force_install_dir ${STEAMAPPDIR} \
	+login ${STEAMLOGIN} \
	+app_license_request ${STEAMAPPID} \
	+app_update ${STEAMAPPID} -beta ${STEAMBETA} ${BETAPASSWORDPARAM} validate \
	+quit

chmod +x ${STEAMAPPDIR}/dotnet-install.sh
${STEAMAPPDIR}/dotnet-install.sh --channel ${DOTNETVERSION} --runtime dotnet --install-dir ${STEAMAPPDIR}/dotnet-runtime

find ${STEAMAPPDIR}/Headless/Data/Assets -type f -atime +7 -delete
find ${STEAMAPPDIR}/Headless/Cache -type f -atime +7 -delete
find /Logs -type f -name *.log -atime +30 -delete
mkdir -p Headless/Migrations

mkdir -p ${STEAMAPPDIR}/Headless/Libraries ${STEAMAPPDIR}/Headless/rml_libs ${STEAMAPPDIR}/Headless/rml_mods ${STEAMAPPDIR}/Headless/rml_config
cd ${STEAMAPPDIR}/Headless/Libraries && curl -s https://api.github.com/repos/resonite-modding-group/ResoniteModLoader/releases/latest | grep "browser_download_url.*ResoniteModLoader.dll" | cut -d : -f 2,3 | tr -d \" | wget -qi -
cd ${STEAMAPPDIR}/Headless/rml_libs && curl -s https://api.github.com/repos/resonite-modding-group/ResoniteModLoader/releases/latest | grep "browser_download_url.*0Harmony.dll" | cut -d : -f 2,3 | tr -d \" | wget -qi -

exec $*
