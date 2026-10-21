#ifndef __CDCE62005_REG_MAP_H__
#define __CDCE62005_REG_MAP_H__

#define REGISTER_0_ADDRESS   0x00
#define REGISTER_1_ADDRESS   0x01
#define REGISTER_2_ADDRESS   0x02
#define REGISTER_3_ADDRESS   0x03
#define REGISTER_4_ADDRESS   0x04
#define REGISTER_5_ADDRESS   0x05
#define REGISTER_6_ADDRESS   0x06
#define REGISTER_7_ADDRESS   0x07
#define REGISTER_8_ADDRESS   0x08

#define REG0_PRIMARY_REFERENCE_gp           (0)
#define REG0_PRIMARY_REFERENCE_3_STATE      (0 << REG0_PRIMARY_REFERENCE_gp)
#define REG0_PRIMARY_REFERENCE_DIV_BY_1     (1 << REG0_PRIMARY_REFERENCE_gp)
#define REG0_PRIMARY_REFERENCE_DIV_BY_2     (2 << REG0_PRIMARY_REFERENCE_gp)

#define REG1_SECONDARY_REFERENCE_gp         (0)
#define REG1_SECONDARY_REFERENCE_3_STATE    (0 << REG0_SECONDARY_REFERENCE_gp)
#define REG1_SECONDARY_REFERENCE_DIV_BY_1   (1 << REG0_SECONDARY_REFERENCE_gp)
#define REG1_SECONDARY_REFERENCE_DIV_BY_2   (2 << REG0_SECONDARY_REFERENCE_gp)

#define REG2_REF_DIV_0_bp                   (0)
#define REG2_REF_DIV_1_bp                   (1)
#define REG3_REF_DIV_2_bp                   (0)

// Add additional delay (6us) after rise edge of sync
#define REG4_SYNC_MODE1_bp                  (1)

#define REG5_INPUT_BUFFER_SELECT_gp         (0)
#define REG5_INPUT_BUFFER_SELECT_LVCMOS     (0 << REG5_INPUT_BUFFER_SELECT_gp)
#define REG5_INPUT_BUFFER_SELECT_LVPECL     (2 << REG5_INPUT_BUFFER_SELECT_gp)
#define REG5_INPUT_BUFFER_SELECT_LVDS       (3 << REG5_INPUT_BUFFER_SELECT_gp)

#define REG5_PRISEL_bp                      (2)
#define REG5_SECSEL_bp                      (3)
#define REG5_AUXSEL_bp                      (4)
#define REG5_PRISEL                         (1 << REG5_PRISEL_bp)
#define REG5_SECSEL                         (1 << REG5_SECSEL_bp)
#define REG5_AUXSEL                         (1 << REG5_AUXSEL_bp)
#define REG5_SMART_MUX_PRI_SEC_AUX          (REG5_PRISEL | REG5_SECSEL_bp | REG5_AUXSEL)

#define REG5_EECLKSEL_bp                    (5)
#define REG5_SMART_MUX_ENABLE               (1 << REG5_EECLKSEL_bp)

#define REG5_AC_DC_SEL_bp                   (6)
#define REG5_DC_TERMINATION                 (1 << REG5_AC_DC_SEL_bp)
#define REG5_AC_TERMINATION                 (0 << REG5_AC_DC_SEL_bp)

#define REG5_HYSTEN_bp                      (7)
// Recommended
#define REG5_HYST_ENABLE                    (1 << REG5_HYSTEN_bp)
#define REG5_HYST_DISABLE                   (0 << REG5_HYSTEN_bp)

#define REG8_PRIACTIVITY_bp                 (25)
#define REG8_SECACTIVITY_bp                 (26)
#define REG8_AUXACTIVITY_bp                 (27)

#define REG8_PRIACTIVITY_bm                 (1 << REG8_PRIACTIVITY_bp)
#define REG8_SECACTIVITY_bm                 (1 << REG8_SECACTIVITY_bp)
#define REG8_AUXACTIVITY_bm                 (1 << REG8_AUXACTIVITY_bp)


// OUTPUTS in register from 0 to
// Output mux n select
#define OUT_MUXn_SEL_gp                     (4)
#define OUT_MUXn_SEL_PRI_REF                (0 << OUT_MUXn_SEL_gp)
#define OUT_MUXn_SEL_SEC_REF                (1 << OUT_MUXn_SEL_gp)
#define OUT_MUXn_SEL_SMART_MUX              (2 << OUT_MUXn_SEL_gp)
#define OUT_MUXn_SEL_VCO_CORE               (3 << OUT_MUXn_SEL_gp)

#define PHASEn_ADJUST_gc                    (6)
#define OUTn_DIVIDER_SEL_gc                 (13)
#define OUTn_DIVSEL_bp                      (20)
#define OUTn_DIVSEL_ENABLE                  (1 << OUTn_DIVSEL_bp)
#define OUTn_DIVSEL_DISABLE                 (0 << OUTn_DIVSEL_bp)
#define HIGH_SWING_LVPECL_bp                (21)
#define HIGH_SWING_LVPECL_ENABLE            (1 << HIGH_SWING_LVPECL_bp)
#define HIGH_SWING_LVPECL_DISABLE           (0 << HIGH_SWING_LVPECL_bp)

#define CMOS_MODE_POSITIVE_PIN_gp           (22)
#define CMOS_MODE_NEGATIVE_PIN_gp           (24)
#define CMOS_MODE_ACTIVE_POSITIVE_PIN       (0 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_ACTIVE_NEGATIVE_PIN       (0 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_INVERTING_POSITIVE_PIN    (1 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_INVERTING_NEGATIVE_PIN    (1 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_LOW_POSITIVE_PIN          (2 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_LOW_NEGATIVE_PIN          (2 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_3STATE_POSITIVE_PIN       (3 << CMOS_MODE_POSITIVE_PIN_gp)
#define CMOS_MODE_3STATE_NEGATIVE_PIN       (3 << CMOS_MODE_POSITIVE_PIN_gp)

#define OUTPUT_BUFFER_SELECT_gc             (26)
#define OUTPUT_BUFFER_SELECT_LVPECL         (0b100000 << CMOS_MODE_POSITIVE_PIN_gp)
#define OUTPUT_BUFFER_SELECT_LVDS           (0b111010 << CMOS_MODE_POSITIVE_PIN_gp)
#define OUTPUT_BUFFER_SELECT_LVCMOS         (0 << OUTPUT_BUFFER_SELECT_gc)
#define OUTPUT_BUFFER_SELECT_DISABLE        (0b011010 << CMOS_MODE_POSITIVE_PIN_gp)



#endif
