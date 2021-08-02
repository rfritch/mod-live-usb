######################################
#
# mod-ui
#
######################################

# The mod-ui revision must necessarily be from branch `plugin-store`
MOD_UI_VERSION = 72c2b4785967efbe9af039acef9d03ff44e23587
MOD_UI_SITE = $(call github,moddevices,mod-ui,$(MOD_UI_VERSION))
MOD_UI_DEPENDENCIES = python3 python-aggdraw python-pillow python-pycrypto python-pystache python-setuptools python-serial python-tornado host-python3 jack2mod lilv
MOD_UI_SETUP_TYPE = distutils
MOD_UI_ENV = CXX=$(TARGET_CXX)

$(eval $(python-package))
