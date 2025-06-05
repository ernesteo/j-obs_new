
var disabled_list = [];
disabled_list.push("cls_ath", "cls_rsn", "dcls_yr", "dcls_mon", "dcls_day", "dcls_txt");
// unclassified disabling of clas security form input
disabled_list.push("cls_doc", "cls_cvt", "dcls_tday");
var disabled_list_cnt = disabled_list.length;

var minimal_list = [];
var minimal_list_cnt = minimal_list.length;

var cyan_list = [];
cyan_list.push("observer_title", "observer", "csgn_name", "ship_title", "ship_name");
//cyan_list.push("obs_yr", "obs_mo", "obs_day", "obs_hr", "obs_min");
// unclassified disabling of clas security form input
//cyan_list.push("clas_type", "cls_doc", "dcls_tday");
cyan_list.push("lat", "lon");
var cyan_list_cnt = cyan_list.length;

var yellow_list = [];
var yellow_list_cnt = yellow_list.length;

var silver_list = [];
silver_list.push("email");
//silver_list.push("cls_cvt");
var silver_list_cnt = silver_list.length;
