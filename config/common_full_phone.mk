# Inherit common stuff
$(call inherit-product, vendor/sokp/config/common.mk)
$(call inherit-product, vendor/sokp/config/common_apn.mk)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk
