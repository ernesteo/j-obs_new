
function redo_cls(value)
{

  value = document.forms[0].clas_type.value;
  var divs = document.getElementsByTagName("div");
  for (var i=0; i<divs.length; i++) {
    //need to check for attribute name for being a sec banner
    if (divs[i].className == "sec-unclass-bnr" ||
        divs[i].className == "sec-confid-bnr" ||
        divs[i].className == "sec-secret-bnr")
    {
      var bannerStyle;
      var bannerText;
      if (value == "U")
      {
        bannerStyle = new String("sec-unclass-bnr");
        bannerText = new String("UNCLASSIFIED");
      }
      else if (value == "C")
      {
        bannerStyle = new String("sec-confid-bnr");
        bannerText = new String("CONFIDENTIAL");
      }
      else
      {
        bannerStyle = new String("sec-secret-bnr");
        bannerText = new String("SECRET");
      }
    
          divs[i].className = bannerStyle;  // works in IE
          var kids = divs[i].childNodes;
          for (var j=0; j<kids.length; j++)
          {
            if (kids[j].nodeType == 3 )
            {
              var newNode = document.createTextNode( bannerText );
              divs[i].replaceChild(newNode, kids[j] );
            }
          }
    }
  }

  if(value == "S" || value == "C")
  {
    document.forms[0].dcls_sel[0].disabled=false;
    document.forms[0].dcls_sel[1].disabled=false;
    document.forms[0].dcls_sel[2].disabled=false;
    document.forms[0].cls_sel[0].disabled=false;
    document.forms[0].cls_sel[1].disabled=false;
    document.forms[0].cls_sel[0].checked=true;
    document.forms[0].dcls_sel[0].checked=true;
    document.forms[0].cls_ath.style.backgroundColor="#808080";
    document.forms[0].cls_ath.disabled=true;
    document.forms[0].cls_ath.value="";
    document.forms[0].cls_rsn.style.backgroundColor="#808080";
    document.forms[0].cls_rsn.disabled=true;
    document.forms[0].cls_rsn.value="";
    document.forms[0].cls_doc.style.backgroundColor="cyan";
    document.forms[0].cls_doc.disabled=false;
    document.forms[0].cls_cvt.style.backgroundColor="silver";
    document.forms[0].cls_cvt.disabled=false;
    document.forms[0].dcls_yr.style.backgroundColor="#808080";
    document.forms[0].dcls_yr.disabled=true;
    document.forms[0].dcls_yr.value="";
    document.forms[0].dcls_mon.style.backgroundColor="#808080";
    document.forms[0].dcls_mon.disabled=true;
    document.forms[0].dcls_mon.value="";
    document.forms[0].dcls_day.style.backgroundColor="#808080";
    document.forms[0].dcls_day.disabled=true;
    document.forms[0].dcls_day.value="";
    document.forms[0].dcls_tday.style.backgroundColor="cyan";
    document.forms[0].dcls_tday.disabled=false;
    document.forms[0].dcls_tday.value="365";
    document.forms[0].dcls_txt.style.backgroundColor="#808080";
    document.forms[0].dcls_txt.disabled=true;
    document.forms[0].dcls_txt.value="";
  }
  else if(value == "U")
  {
    document.forms[0].dcls_sel[0].disabled=true;
    document.forms[0].dcls_sel[1].disabled=true;
    document.forms[0].dcls_sel[2].disabled=true;
    document.forms[0].cls_sel[0].disabled=true;
    document.forms[0].cls_sel[1].disabled=true;
    document.forms[0].cls_ath.style.backgroundColor="#808080";
    document.forms[0].cls_ath.disabled=true;
    document.forms[0].cls_ath.value="";
    document.forms[0].cls_rsn.style.backgroundColor="#808080";
    document.forms[0].cls_rsn.disabled=true;
    document.forms[0].cls_rsn.value="";
    document.forms[0].cls_doc.style.backgroundColor="#808080";
    document.forms[0].cls_doc.disabled=true;
    document.forms[0].cls_doc.value="";
    document.forms[0].cls_cvt.style.backgroundColor="#808080";
    document.forms[0].cls_cvt.disabled=true;
    document.forms[0].cls_cvt.value="";
    document.forms[0].dcls_yr.style.backgroundColor="#808080";
    document.forms[0].dcls_yr.disabled=true;
    document.forms[0].dcls_yr.value="";
    document.forms[0].dcls_mon.style.backgroundColor="#808080";
    document.forms[0].dcls_mon.disabled=true;
    document.forms[0].dcls_mon.value="";
    document.forms[0].dcls_day.style.backgroundColor="#808080";
    document.forms[0].dcls_day.disabled=true;
    document.forms[0].dcls_day.value="";
    document.forms[0].dcls_tday.style.backgroundColor="#808080";
    document.forms[0].dcls_tday.disabled=true;
    document.forms[0].dcls_tday.value="";
    document.forms[0].dcls_txt.style.backgroundColor="#808080";
    document.forms[0].dcls_txt.disabled=true;
    document.forms[0].dcls_txt.value="";
  }
}
    
function reset_dcls(value)
{
  theElement = document.getElementById('dcls_sel');
  if(value == 1)
  {
    document.forms[0].dcls_yr.style.backgroundColor="#808080";
    document.forms[0].dcls_yr.disabled=true;
    document.forms[0].dcls_yr.value="";
    document.forms[0].dcls_mon.style.backgroundColor="#808080";
    document.forms[0].dcls_mon.disabled=true;
    document.forms[0].dcls_mon.value="";
    document.forms[0].dcls_day.style.backgroundColor="#808080";
    document.forms[0].dcls_day.disabled=true;
    document.forms[0].dcls_day.value="";
    document.forms[0].dcls_tday.style.backgroundColor="cyan";
    document.forms[0].dcls_tday.disabled=false;
    document.forms[0].dcls_tday.value="365";
    document.forms[0].dcls_txt.style.backgroundColor="#808080";
    document.forms[0].dcls_txt.disabled=true;
    document.forms[0].dcls_txt.value="";
  }
  else if(value == 2)
  {
    document.forms[0].dcls_yr.style.backgroundColor="cyan";
    document.forms[0].dcls_yr.disabled=false;
    document.forms[0].dcls_mon.style.backgroundColor="cyan";
    document.forms[0].dcls_mon.disabled=false;
    document.forms[0].dcls_day.style.backgroundColor="cyan";
    document.forms[0].dcls_day.disabled=false;
    document.forms[0].dcls_tday.style.backgroundColor="#808080";
    document.forms[0].dcls_tday.disabled=true;
    document.forms[0].dcls_tday.value="";
    document.forms[0].dcls_txt.style.backgroundColor="#808080";
    document.forms[0].dcls_txt.disabled=true;
    document.forms[0].dcls_txt.value="";
  }
  else
  {
    document.forms[0].dcls_yr.style.backgroundColor="#808080";
    document.forms[0].dcls_yr.disabled=true;
    document.forms[0].dcls_yr.value="";
    document.forms[0].dcls_mon.style.backgroundColor="#808080";
    document.forms[0].dcls_mon.disabled=true;
    document.forms[0].dcls_mon.value="";
    document.forms[0].dcls_day.style.backgroundColor="#808080";
    document.forms[0].dcls_day.disabled=true;
    document.forms[0].dcls_day.value="";
    document.forms[0].dcls_tday.style.backgroundColor="#808080";
    document.forms[0].dcls_tday.disabled=true;
    document.forms[0].dcls_tday.value="";
    document.forms[0].dcls_txt.style.backgroundColor="cyan";
    document.forms[0].dcls_txt.disabled=false;
  }
  return true;
}

function reset_cls(value)
{
  if(value == 1)
  {
    document.forms[0].cls_ath.style.backgroundColor="#808080";
    document.forms[0].cls_ath.disabled=true;
    document.forms[0].cls_ath.value="";
    document.forms[0].cls_rsn.style.backgroundColor="#808080";
    document.forms[0].cls_rsn.disabled=true;
    document.forms[0].cls_rsn.value="";
    document.forms[0].cls_doc.style.backgroundColor="cyan";
    document.forms[0].cls_doc.disabled=false;
    document.forms[0].cls_sel[1].checked=true;
  }
  else
  {
    document.forms[0].cls_ath.style.backgroundColor="cyan";
    document.forms[0].cls_ath.disabled=false;
    document.forms[0].cls_rsn.style.backgroundColor="cyan";
    document.forms[0].cls_rsn.disabled=false;
    document.forms[0].cls_doc.style.backgroundColor="#808080";
    document.forms[0].cls_doc.disabled=true;
    document.forms[0].cls_doc.value="";
    document.forms[0].cls_sel[0].checked=true;
  }
  return true;
}
