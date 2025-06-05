cyan_list.push("obs_yr", "obs_mo", "obs_day", "obs_hr", "obs_min");
// part 1
cyan_list.push("rpt_typ_id", "wnd_dir", "wnd_spd", "wnd_mthd");
cyan_list.push("horz_sfc_vsby", "tot_cld_amt_id");
cyan_list.push("air_temp", "dwpt", "wet_bulb_temp");
cyan_list.push("stn_lvl_pres", "sea_lvl_pres", "alt_set");
cyan_list.push("lat", "lon", "mv_plfm_dir_1", "mv_plfm_spd_1");
cyan_list.push("sea_temp");
var cyan_list_cnt = cyan_list.length;

// part 1
yellow_list.push("prsnt_wx", "wnd_gst", "wnd_vrb_1", "wnd_vrb_2");
yellow_list.push("rmrks");
yellow_list.push("wnd_wav_per", "wnd_wav_ht");
yellow_list.push("pri_swl_wav_dir", "pri_swl_wav_ht", "pri_swl_wav_per");
yellow_list.push("scdy_swl_wav_dir", "scdy_swl_wav_ht", "scdy_swl_wav_per");
var yellow_list_cnt = yellow_list.length;

// part 1
silver_list.push("sky_cdn");
// part 2
silver_list.push("cld_base_ht_id", "horz_sfc_vsby_id");
silver_list.push("pres_tdcy_char_id", "pres_tdcy_amt");
silver_list.push("pres_wx_id", "past_wx_id_1", "past_wx_id_2");
silver_list.push("low_cld_amt_id", "low_cld_type_id", "mid_cld_type_id", "hi_cld_type_id");
silver_list.push("mv_plfm_dir_id", "mv_plfm_spd_id");
silver_list.push("ice_accr_cause_id", "ice_accr_thkn", "ice_accr_rate_id", "sea_ice_conc_id");
silver_list.push("ice_dev_stage_id", "ice_type_amt_id", "ice_edge_brg_id", "ice_sit_id");
silver_list.push("stn_ht", "rel_hum", "wet_bulb_temp_mthd", "sea_temp_mthd");
silver_list.push("icing_rmrk", "ice_rmrk");
var silver_list_cnt = silver_list.length;

// Define Part 2 parameters that switch priorities for the 00, 03, ... obs hours
// reset paramteres listed in part2_list as cyan (required)

var part2_list = [
'cld_base_ht_id',
'horz_sfc_vsby_id',
'pres_wx_id',
'past_wx_id_1',
'past_wx_id_2',
'low_cld_amt_id',
'low_cld_type_id',
'mid_cld_type_id',
'hi_cld_type_id',
'mv_plfm_dir_id',
'mv_plfm_spd_id'
];
var part2_cnt = parseInt(part2_list.length);

// Define all names for Part 2 parameters

var part2_name_list = [
'cld_base_ht_id',
'horz_sfc_vsby_id',
'pres_tdcy_char_id',
'pres_tdcy_amt',
'pres_wx_id',
'past_wx_id_1',
'past_wx_id_2',
'low_cld_amt_id',
'low_cld_type_id',
'mid_cld_type_id',
'hi_cld_type_id',
'mv_plfm_dir_id',
'mv_plfm_spd_id',
'ice_accr_cause_id',
'ice_accr_thkn',
'ice_accr_rate_id',
'sea_ice_conc_id',
'ice_dev_stage_id',
'ice_type_amt_id',
'ice_edge_brg_id',
'ice_sit_id'
];
var part2_name_cnt = parseInt(part2_name_list.length);

// Define all values for Part 2 parameters

var part2_value_list = [
'/',
'//',
'',
'',
'',
'',
'',
'/',
'/',
'/',
'/',
'/',
'/',
'',
'',
'',
'',
'',
'',
'',
''
];
var part2_value_cnt = parseInt(part2_value_list.length);

// Define Part 1 parameter array accordin to report type
// The following lists are used in reset_parm when rpt_typ_id is changed.
//   parm_list_pos is list of parameters always set to yellow
//   parm_list_1 is list of parameters set to cyan for METAR
//   parm_list_2 is list of parameters set to cyan for SPECI
//   parm_list_3_5 is list of parameters set to cyan for SPECI special circumstances
//   parm_list_6 is list of parameters set to cyan for SPECI local requirements

var parm_list_pos = [
"wnd_wav_per",
"wnd_wav_ht",
"pri_swl_wav_dir",
"pri_swl_wav_ht",
"pri_swl_wav_per",
"scdy_swl_wav_dir",
"scdy_swl_wav_ht",
"scdy_swl_wav_per"
];
var parm_list_pos_cnt = parm_list_pos.length;

var parm_list_1 = [
"sea_lvl_pres",
"air_temp",
"dwpt",
"wet_bulb_temp",
"alt_set",
"stn_lvl_pres",
"tot_cld_amt_id",
"sea_temp",
"wnd_wav_per",
"wnd_wav_ht",
"pri_swl_wav_dir",
"pri_swl_wav_ht",
"pri_swl_wav_per",
"scdy_swl_wav_dir",
"scdy_swl_wav_ht",
"scdy_swl_wav_per"
];
var parm_list_1_cnt = parm_list_1.length;

var parm_list_2 = [
"alt_set",
"sea_temp"
];
var parm_list_2_cnt = parm_list_2.length;

var parm_list_3_5 = [
"air_temp",
"dwpt",
"wet_bulb_temp",
"alt_set",
"tot_cld_amt_id",
"wnd_wav_per",
"wnd_wav_ht",
"pri_swl_wav_dir",
"pri_swl_wav_ht",
"pri_swl_wav_per",
"scdy_swl_wav_dir",
"scdy_swl_wav_ht",
"scdy_swl_wav_per"
];
var parm_list_3_5_cnt = parm_list_3_5.length;

var parm_list_6 = [
"air_temp",
"sea_temp",
"wnd_wav_per",
"wnd_wav_ht",
"pri_swl_wav_dir",
"pri_swl_wav_ht",
"pri_swl_wav_per",
"scdy_swl_wav_dir",
"scdy_swl_wav_ht",
"scdy_swl_wav_per"
];
var parm_list_6_cnt = parm_list_6.length;
