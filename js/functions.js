function convertBinary()
{
  var output = document.getElementById("outputBinary");
  var input = document.getElementById("inputBinary").value;
  output.value = "";
  for (i=0; i < input.length; i++)
  {
    var e=input[i].charCodeAt(0);var s = "";
    do
    {
      var a =e%2;
      e=(e-a)/2;
      s=a+s;
    }
    while(e!=0);
    while(s.length<8){s="0"+s;}
    output.value+=s;
  }
}

function check_accept_location()
{
  // test_var is an object node list
  var test_var=document.getElementsByName('accept_location');
  var test_value;
  test_value="nsr"
  for (var i = 0; i < test_var.length; i++)
  {
    if(test_var[i].checked)
    {
      test_value=test_var[i].value;
      break;
    }
  }

  if(test_value == "yes")
  { 
    return true;
  }
  else if(test_value == "no")
  {
    alert("redo location");
    window.open('','wmo_form').close();
    return true;
  }
  else
  {
    alert("You must choose yes or no");
    return false;
  }
}

function search_cs()
{
  var input=document.getElementById('csgn_name').value;
  var output=document.getElementById('csgn_name_list').options;
  var output_title=document.getElementById('ship_title').options;
  var input_length=input.length;
  for(var i=0;i<output.length;i++)
  {
    if(output[i].value.search(input)==0)
    {
      output[i].selected=true;
      if(input_length==4)
      {
        document.getElementById('ship_name').value=output[i].value.substring(output[i].value.indexOf(" ")+1);
        if(output[i].value.substring(5,output[i].value.indexOf(" ")) == "USS")
        {
          output_title[0].selected=true;
        }
        else if(output[i].value.substring(5,output[i].value.indexOf(" ")) == "USNS")

        {
          output_title[1].selected=true;
        }
        else
        {
          output_title[2].selected=true;
        }

        document.getElementById('ship_name').style.backgroundColor="cyan";
        document.getElementById('csgn_name').style.backgroundColor="cyan";
      }
      break;
    }

    if(document.forms[0].csgn_name.value=='')
    {
      document.getElementById('ship_name').value='';
      document.getElementById('ship_name').style.backgroundColor="pink";
      document.getElementById('csgn_name').style.backgroundColor="pink";
      output[0].selected=true;
      break;
    }

    if(input_length==4)
    {
      document.getElementById('ship_name').value='';
      document.getElementById('ship_name').style.backgroundColor="pink";
      document.getElementById('csgn_name').style.backgroundColor="pink";
      output[1].selected=true;
    }
    else
    {
      document.getElementById('ship_name').value='';
      document.getElementById('ship_name').style.backgroundColor="pink";
      document.getElementById('csgn_name').style.backgroundColor="pink";
      output[0].selected=true;
    }
  }
}

function select_cs()
{
  var input=document.getElementById('csgn_name_list').value;
  var output_title=document.getElementById('ship_title').options;
  if(input.substring(0,4) != "ZZZZ")
  {
    document.getElementById('ship_name').value=input.substring(input.indexOf(" ")+1);
    document.getElementById('ship_name').style.backgroundColor="cyan";
    document.getElementById('csgn_name').style.backgroundColor="cyan";
    if(input.substring(5,input.indexOf(" ")) == "USS")
    {
      output_title[0].selected=true;
    }
    else if(input.substring(5,input.indexOf(" ")) == "USNS")
    {
      output_title[1].selected=true;
    }
    else
    {
      output_title[2].selected=true;
    }
    document.getElementById('csgn_name').value=input.substring(0,4);
  }
  else
  {
    document.getElementById('ship_name').value="";
    document.getElementById('ship_name').style.backgroundColor="pink";
    document.getElementById('csgn_name').style.backgroundColor="pink";
  }
}


// general functions
function set_time()
{
  var today = new Date();
  document.write(today);
  full_year=today.getUTCFullYear();
  document.forms[0].obs_yr.value=full_year;
  short_month=today.getUTCMonth()+1;
  document.forms[0].obs_mo.value=short_month;
  short_day=today.getUTCDate();
  document.forms[0].obs_day.value=short_day;
  short_hour=today.getUTCHours();
  if (short_hour >= 12)
  {
    short_hour=12
  }
  else
  {
    short_hour=0
  }
  document.forms[0].obs_hr.value=short_hour;
  short_minute=today.getUTCMinutes();
//  document.forms[0].obs_min.value=short_minute;
  document.forms[0].obs_min.value=0;
  short_second=today.getUTCSeconds();
  document.forms[0].client_receive_time.value=full_year+"_"+short_month+"_"+short_day+"_"+short_hour+"_"+short_minute+"_"+short_second;
}

function check_email_clas(email,id)
{
  var i;
  var j;
  var chr_match;
  var sr;
  var bg;
  var validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.";
  var invalidChars = " /:,;";
  var theElement;
  var atPos = email.indexOf("@");
//var atEnd = email.indexOf(".smil.mil");
  var atEnd = email.indexOf(".mil");
  var dbpPos = email.indexOf("..");
  var stopPos = email.lastIndexOf(".");
  theElement = document.getElementById(id);

  if (email == "")
  {
    theElement.style.backgroundColor="silver";
    return true;
//  theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
//  alert('Must enter email');
//  return false;
  }

  for (i=0; i<email.length; i++)
  { 
    sr = email.charAt(i);
    chr_match = false;
    for(j=0; j<validChars.length; j++)
    {
      bg = validChars.charAt(j);
      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if(!chr_match)
    {
      theElement.style.backgroundColor="pink";
      alert('Invalid email character(s)');
      return false;
    }
  } 

  for (i=0; i<invalidChars.length; i++) {
    badChar = invalidChars.charAt(i);
    if (email.indexOf(badChar,0) > -1)
    {
      theElement.style.backgroundColor="pink";
//    theElement.focus();
//    theElement.select();
      alert('Invalid email address');
      return false;
    }
  }

// make sure @ and . exist
  if (atPos == -1 || stopPos == -1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure the last . is to the right of @
  if (stopPos < atPos)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure there is at least one character between @ and last .
  if (stopPos - atPos == 1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure only one @ occrus
  if (email.indexOf("@",atPos+1) > -1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure at least 2 characters are after last .
  if (stopPos+3 > email.length)
  {
//  theElement.focus();
//  theElement.select();
    theElement.style.backgroundColor="pink";
    alert('Invalid email address');
    return false;
  }

// make sure at least one characters before @
  if (atPos < 1)
  {
//  theElement.focus();
//  theElement.select();
    theElement.style.backgroundColor="pink";
    alert('Invalid email address');
    return false;
  }

// make sure ".smil.mil" occures at the end of the email address
//if (email.length != atEnd+9)
// make sure ".mil" occures at the end of the email address
  if (email.length != atEnd+4)
  {
    theElement.style.backgroundColor="pink";
    alert('Invalid email address ending.  .mil is required');
    return false;
  }

// check for multiple periods
  if (dbpPos != -1 )
  {
    theElement.style.backgroundColor="pink";
    alert('Invalid email address using multiple periods');
    return false;
  }

  theElement.style.backgroundColor="silver";
  return true;

}

function check_email_unclas(email,id,ovrd)
{
  var i;
  var j;
  var chr_match;
  var sr;
  var bg;
  var validChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@.";
  var invalidChars = " /:,;";
  var theElement;
  var atPos = email.indexOf("@");
  var atEnd = email.indexOf(".mil");
  var dbpPos = email.indexOf("..");
  var stopPos = email.lastIndexOf(".");
  theElement = document.getElementById(id);

  if (email == "")
  {
    theElement.style.backgroundColor="silver";
    return true;
//  theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
//  alert('Must enter email');
//  return false;
  }

  for (i=0; i<email.length; i++)
  { 
    sr = email.charAt(i);
    chr_match = false;
    for(j=0; j<validChars.length; j++)
    {
      bg = validChars.charAt(j);
      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if(!chr_match)
    {
      theElement.style.backgroundColor="pink";
      alert('Invalid email character(s)');
      return false;
    }
  } 

  for (i=0; i<invalidChars.length; i++)
  {
    badChar = invalidChars.charAt(i);
    if (email.indexOf(badChar,0) > -1)
    {
      theElement.style.backgroundColor="pink";
//    theElement.focus();
//    theElement.select();
      alert('Invalid email address');
      return false;
    }
  }

// make sure @ and . exist
  if (atPos == -1 || stopPos == -1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure the last . is to the right of @
  if (stopPos < atPos)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure there is at least one character between @ and last .
  if (stopPos - atPos == 1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure only one @ occrus
  if (email.indexOf("@",atPos+1) > -1)
  {
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Invalid email address');
    return false;
  }

// make sure at least 2 characters are after last .
  if (stopPos+3 > email.length)
  {
//  theElement.focus();
//  theElement.select();
    theElement.style.backgroundColor="pink";
    alert('Invalid email address');
    return false;
  }

// make sure at least one characters before @
  if (atPos < 1)
  {
//  theElement.focus();
//  theElement.select();
    theElement.style.backgroundColor="pink";
    alert('Invalid email address');
    return false;
  }

// make sure "mil" occures at the end of the email address
  if (email.length != atEnd+4)
  {
    theElement.style.backgroundColor="pink";
    alert('Invalid email address ending.  .mil is required');
    alert(email);
    return false;
  }

// check for multiple periods
  if (dbpPos != -1 )
  {
    theElement.style.backgroundColor="pink";
    alert('Invalid email address using multiple periods');
    return false;
  }

  if(ovrd == "")
  {
    theElement.style.backgroundColor="silver";
  }
  else
  {
    theElement.style.backgroundColor="white";
  }
  return true;

}



function check_ship_call_sign(ship_name,id)
{
  var theElement;
  if (ship_name == "")
  {
    theElement = document.getElementById(id);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
//  alert('Must enter call sign');
    return false;
  }
  if (ship_name.length != "4")
  {
    theElement = document.getElementById(id);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Must be 4 characters');
    return false;
  }
  for (i=0; i<4; i++)
  {
    if (ship_name.charAt(i) >= "0" && ship_name.charAt(i) <= "9")
      {
        theElement = document.getElementById(id);
        theElement.style.backgroundColor="pink";
//      theElement.focus();
//      theElement.select();
        alert('No numbers');
        return false;
      }
  }
  if (!check_str(ship_name))
  {
    theElement = document.getElementById(id);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('No strange characters');
    return false;
  }
  theElement = document.getElementById(id);
  theElement.style.backgroundColor="cyan";
  return true;
}

function check_empty_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (str.length == 0)
  {
    if(color == "cyan"|| color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
//  if(color == "yellow")
//  {
//    theElement.style.backgroundColor="#ffc0cb";
//  }
//  if(color == "silver")
//  {
//  theElement.style.backgroundColor="#ffc0cc";
//  }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }
    return false;
  }
  if (!check_str(str))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    return false;
  }
  if(color == "pink" || color == "red")
  {
    theElement.style.backgroundColor="cyan";
  }
  if(color == "#ffc0cb" || color == "#ff0000")
  {
    theElement.style.backgroundColor="yellow";
  }
  if(color == "#ffc0cc" || color == "#ff0001")
  {
  theElement.style.backgroundColor="silver";
  }
  return true;
}

function check_int_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (!check_empty_state(str,id)) return false;
  var i;
  for (i=0; i<str.length; i++)
  if(!(str.charAt(i) == "-" && i == "0"))
  {
    if (str.charAt(i) < "0" || str.charAt(i) > "9" && str != "M")
    {
      if(color == "cyan" || color == "pink" || color == "red")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
      {
      theElement.style.backgroundColor="#ffc0cc";
      }
//    theElement.focus();
//    theElement.select();
      alert('Non-integer');
      return false;
    }
  }

  if(color == "pink" || color == "red")
  {
    theElement.style.backgroundColor="cyan";
  }
  if(color == "#ffc0cb" || color == "#ff0000")
  {
    theElement.style.backgroundColor="yellow";
  }
  if(color == "#ffc0cc" || color == "#ff0001")
  {
  theElement.style.backgroundColor="silver";
  }
  return true;
}

function check_date_state(id)
{
  var theElement;
  str=document.forms[0].obs_yr.value;
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  theElement_obs_day = document.getElementById('obs_day');
  theElement_obs_hr = document.getElementById('obs_hr');
  theElement_obs_min = document.getElementById('obs_min');
  if (!check_int_state(str,id))
  {
    alert("Non integer")
    return false;
  }
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
     document.forms[0].obs_mo.value,
     document.forms[0].obs_day.value,
     document.forms[0].obs_hr.value,
     document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;

}


function check_year_state(id)
{
  var theElement;
  str=document.forms[0].obs_yr.value;
  if (!check_int_state(str,id))
  {
    return false;
  }
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  theElement_obs_day = document.getElementById('obs_day');
  theElement_obs_hr = document.getElementById('obs_hr');
  theElement_obs_min = document.getElementById('obs_min');
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
                 document.forms[0].obs_mo.value,
                 document.forms[0].obs_day.value,
                 document.forms[0].obs_hr.value,
                 document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;

}

function check_month_state(id)
{
  var theElement;
  str=document.forms[0].obs_mo.value;
  if (!check_int_state(str,id))
  {
    return false;
  }
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  if ((document.forms[0].obs_mo.value < 1) || (document.forms[0].obs_mo.value > 12))
  {
    alert("Month value is out of range");
    theElement_obs_mo.style.backgroundColor="pink";
    return false;
  }
  theElement_obs_day = document.getElementById('obs_day');
  theElement_obs_hr = document.getElementById('obs_hr');
  theElement_obs_min = document.getElementById('obs_min');
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
                 document.forms[0].obs_mo.value,
                 document.forms[0].obs_day.value,
                 document.forms[0].obs_hr.value,
                 document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;
}
function check_day_state(id)
{
  var theElement;
  str=document.forms[0].obs_day.value;
  if (!check_int_state(str,id))
  {
    return false;
  }
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  theElement_obs_day = document.getElementById('obs_day');
  if ((document.forms[0].obs_mo.value == 1) || (document.forms[0].obs_mo.value == 3) || (document.forms[0].obs_mo.value == 5) || (document.forms[0].obs_mo.value == 7) || (document.forms[0].obs_mo.value == 8) || (document.forms[0].obs_mo.value == 10) || (document.forms[0].obs_mo.value == 12))
  {
    if ((document.forms[0].obs_day.value < 1) || (document.forms[0].obs_day.value > 31))
    {
      alert("Day value is out of range");
      theElement_obs_day.style.backgroundColor="pink";
      return false;
    }
  }
  if ((document.forms[0].obs_mo.value == 4) || (document.forms[0].obs_mo.value == 9) || (document.forms[0].obs_mo.value == 11))
  {
    if ((document.forms[0].obs_day.value < 1) || (document.forms[0].obs_day.value > 30))
    {
      alert("Day value is out of range");
      theElement_obs_day.style.backgroundColor="pink";
      return false;
    }
  }
  if ((document.forms[0].obs_mo.value == 2))
  {
    if ((document.forms[0].obs_yr.value % 4) == 0)
    {
      if ((document.forms[0].obs_day.value < 1) || (document.forms[0].obs_day.value > 29))
      {
        alert("Day value is out of range");
        theElement_obs_day.style.backgroundColor="pink";
        return false;
      }
    }
    else
    {
      if ((document.forms[0].obs_day.value < 1) || (document.forms[0].obs_day.value > 28))
      {
        alert("Day value is out of range");
        theElement_obs_day.style.backgroundColor="pink";
        return false;
      }
    }
  }
  theElement_obs_hr = document.getElementById('obs_hr');
  theElement_obs_min = document.getElementById('obs_min');
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
                 document.forms[0].obs_mo.value,
                 document.forms[0].obs_day.value,
                 document.forms[0].obs_hr.value,
                 document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;
}

function check_hour_state(id)
{
  var theElement;
  str=document.forms[0].obs_hr.value;
  if (!check_int_state(str,id))
  {
    return false;
  }
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  theElement_obs_day = document.getElementById('obs_day');
  theElement_obs_hr = document.getElementById('obs_hr');
  if ((document.forms[0].obs_hr.value < 0) || (document.forms[0].obs_hr.value > 23))
  {
    alert("Hour value is out of range");
    theElement_obs_hr.style.backgroundColor="pink";
    return false;
  }
  theElement_obs_min = document.getElementById('obs_min');
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
                 document.forms[0].obs_mo.value,
                 document.forms[0].obs_day.value,
                 document.forms[0].obs_hr.value,
                 document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;
}

function check_minute_state(id)
{
  var theElement;
  str=document.forms[0].obs_min.value;
  if (!check_int_state(str,id))
  {
    return false;
  }
  theElement = document.getElementById(id);
  theElement_obs_yr = document.getElementById('obs_yr');
  theElement_obs_mo = document.getElementById('obs_mo');
  theElement_obs_day = document.getElementById('obs_day');
  theElement_obs_hr = document.getElementById('obs_hr');
  theElement_obs_min = document.getElementById('obs_min');
  if ((document.forms[0].obs_min.value < 0) || (document.forms[0].obs_min.value > 59))
  {
    alert("Minute value is out of range");
    theElement_obs_min.style.backgroundColor="pink";
    return false;
  }
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if(!valid_date(document.forms[0].obs_yr.value,
                 document.forms[0].obs_mo.value,
                 document.forms[0].obs_day.value,
                 document.forms[0].obs_hr.value,
                 document.forms[0].obs_min.value))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    return false;
  }

  theElement_obs_yr.style.backgroundColor="cyan";
  theElement_obs_mo.style.backgroundColor="cyan";
  theElement_obs_day.style.backgroundColor="cyan";
  theElement_obs_hr.style.backgroundColor="cyan";
  theElement_obs_min.style.backgroundColor="cyan";

  return true;
}

function check_int_range_state(str,min,max,id)
{
  var theElement;
  if (!check_int_state(str,id)) return false;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (parseInt(str) < parseInt(min) || parseInt(str) > parseInt(max) && str != "M")
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
      theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    alert('is out of range');
    return false;
  }

  if(color == "pink" || color == "red")
  {
    theElement.style.backgroundColor="cyan";
  }
  if(color == "#ffc0cb" || color == "#ff0000")
  {
    theElement.style.backgroundColor="yellow";
  }
  if(color == "#ffc0cc" || color == "#ff0001")
  {
  theElement.style.backgroundColor="silver";
  }
  return true;
}

function check_float_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (!check_empty_state(str,id)) return false;
  var i;
  var seenDecimalPoint = false;

  for (i = 0; i < str.length; i++)
  {
    if(!(str.charAt(i) == "-" && i == "0"))
    {
      if (str.charAt(i) < "0" || str.charAt(i) > "9" && str != "M")
      {
        if (str.charAt(i) == "." && !seenDecimalPoint)
        {
          seenDecimalPoint = true;
        }
        else
        {
          if(color == "cyan" || color == "pink" || color == "red")
          {
            theElement.style.backgroundColor="pink";
          }
          if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
          {
            theElement.style.backgroundColor="#ffc0cb";
          }
          if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
          {
          theElement.style.backgroundColor="#ffc0cc";
          }
//        theElement.focus();
//        theElement.select();
          alert('Non-number');
          return false;
        }
      }
    }
  }

  if(color == "pink" || color == "red")
  {
    theElement.style.backgroundColor="cyan";
  }
  if(color == "#ffc0cb" || color == "#ff0000")
  {
    theElement.style.backgroundColor="yellow";
  }
  if(color == "#ffc0cc" || color == "#ff0001")
  {
  theElement.style.backgroundColor="silver";
  }
  return true;
}

function check_float_range_depth(id,id_pre)
{
  var units = document.getElementById("units").value;
  var min = 0;      // meters
  var max = 750;    // meters
  var theElement;
  var theElement_pre;
  theElement = document.getElementById(id);
  theElement_pre = document.getElementById(id_pre);
  var color = theElement.style.backgroundColor;
  var str = parseFloat(theElement.value);
  var str_pre = parseFloat(theElement_pre.value);
  if (check_float_state(str,id))
  {
    color = theElement.style.backgroundColor;
    if(units == "9")  // convert to metric, ft --> m
    {
      min = min * 3.279;
      max = max * 3.279;
    }
    if (str < min || str > max && str != "M")
    {
      if(color == "cyan")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "#ffc0cb")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is out of range --  min="+min+" max="+max);
      return false;
    }

    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }

    if(str < str_pre && check_empty_state(theElement_pre.value,id_pre))
    {
      if(color == "cyan")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is less than previous depth, "+str_pre);
      return false;
    }

    return true;
  }
  else
  {
    return false;
  }
}

function check_float_range_temp(id)
{
  var units = document.getElementById("units").value;
  var min = -2.1;      // C
  var max =  40.0;     // C
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  var str = parseFloat(theElement.value);
  if (check_float_state(str,id))
  {
    color = theElement.style.backgroundColor;
    if(units == "9")  // convert to metric, ft --> m
    {
      min = min * 1.8 + 32.0;
      max = max * 1.8 + 32.0;
    }
    if (str < min || str > max && str != "M")
    {
      if(color == "cyan")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is out of range --  min="+min+" max="+max);
      return false;
    }

    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }

    return true;
  }
  else
  {
    return false;
  }
}

function check_zz_float_range_state(str,id)
{
// work in progress
// #ffc0cb --> rgb(255, 192, 203)
// #ffc0cc --> rgb(255, 192, 204)
// #ff0000 --> rgb(255, 0, 0)
// #ff0001 --> rgb(255, 0, 1)
//
//alert(str);
//alert(id);
  var min = 0;
  var max = 10000;
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (check_float_state(str,id))
  {
    color = theElement.style.backgroundColor;
    if (parseFloat(str) < parseFloat(min) || parseFloat(str) > parseFloat(max) && str != "M")
    {
      if(color == "cyan" || color == "pink" || color == "red")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is out of range --  min="+min+" max="+max);
//    theElement.select();
//    theElement.focus();
      return false;
    }
    else
    {
      if(str != "")
      {
//      alert(color);
        if(color == "pink" || color == "red")
        {
          theElement.style.backgroundColor="cyan";
        }
        if(color == "rgb(255, 192, 203)" || color == "rgb(255, 0, 0)")
        {
          theElement.style.backgroundColor="yellow";
        }
        if(color == "rgb(255, 192, 204)" || color == "rgb(255, 0, 1)")
        {
        theElement.style.backgroundColor="silver";
        }
      }
    return true;
    }
  }
  else
  {
    return false;
  }
}

function check_tt_float_range_state(str,id)
{
// work in progress
// #ffc0cb --> rgb(255, 192, 203)
// #ffc0cc --> rgb(255, 192, 204)
// #ff0000 --> rgb(255, 0, 0)
// #ff0001 --> rgb(255, 0, 1)
//
//alert(str);
//alert(id);
  var min = -2.1;
  var max = 1000.0;
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (check_float_state(str,id))
  {
    color = theElement.style.backgroundColor;
    if (parseFloat(str) < parseFloat(min) || parseFloat(str) > parseFloat(max) && str != "M")
    {
      if(color == "cyan" || color == "pink" || color == "red")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is out of range --  min="+min+" max="+max);
//    theElement.select();
//    theElement.focus();
      return false;
    }
    else
    {
      if(str != "")
      {
//      alert(color);
        if(color == "pink" || color == "red")
        {
          theElement.style.backgroundColor="cyan";
        }
        if(color == "rgb(255, 192, 203)" || color == "rgb(255, 0, 0)")
        {
          theElement.style.backgroundColor="yellow";
        }
        if(color == "rgb(255, 192, 204)" || color == "rgb(255, 0, 1)")
        {
        theElement.style.backgroundColor="silver";
        }
      }
    return true;
    }
  }
  else
  {
    return false;
  }
}

function check_float_range_state(str,min,max,id)
{
// work in progress
// #ffc0cb --> rgb(255, 192, 203)
// #ffc0cc --> rgb(255, 192, 204)
// #ff0000 --> rgb(255, 0, 0)
// #ff0001 --> rgb(255, 0, 1)
//
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (check_float_state(str,id))
  {
    color = theElement.style.backgroundColor;
    if (parseFloat(str) < parseFloat(min) || parseFloat(str) > parseFloat(max) && str != "M")
    {
      if(color == "cyan" || color == "pink" || color == "red")
      {
        theElement.style.backgroundColor="pink";
      }
      if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
      {
        theElement.style.backgroundColor="#ffc0cb";
      }
      if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
      {
        theElement.style.backgroundColor="#ffc0cc";
      }
      alert(str+" is out of range --  min="+min+" max="+max);
//    theElement.select();
//    theElement.focus();
      return false;
    }
    else
    {
      if(str != "")
      {
//      alert(color);
        if(color == "pink" || color == "red")
        {
          theElement.style.backgroundColor="cyan";
        }
        if(color == "rgb(255, 192, 203)" || color == "rgb(255, 0, 0)")
        {
          theElement.style.backgroundColor="yellow";
        }
        if(color == "rgb(255, 192, 204)" || color == "rgb(255, 0, 1)")
        {
        theElement.style.backgroundColor="silver";
        }
      }
    return true;
    }
  }
  else
  {
    return false;
  }
}

function check_wmo_message(str)
{ 
  var i;
  var j;
  var bag = ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-+/\r\n';
  var chr_match;
  var sr;
  var bg;
  for (i = 0; i < str.length; i++)
  { 
    sr = str.charAt(i);
    chr_match = false;
    for(j=0; j<bag.length; j++)
    {
      bg = bag.charAt(j);
      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if(!chr_match) return false;
  } 
  return true;
}

function check_wmo_message_state(textbox_id,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  var str = theElement.value;
  if (!check_wmo_message(str))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    else if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    else if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    alert(str);
    alert('Inappropriate characters in WMO enocoded message');
    alert('Accept only ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-+');
    return false;
  }
  else
  {
    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    else if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    else if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }
    return true;
  }
}

function check_str_int(str,id)
{
  var i;
  var j;
  var bag = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890. ";
  var chr_match;
  var sr;
  var bg;
  if(str.length < 4 || str.length > 9 && id == "stn_id")
  {
    alert("ship or station call sign length must be greater than 3 and less than 10");
    return false;
  }

  for (i = 0; i < str.length; i++)
  {
    sr = str.charAt(i);
    chr_match = false;
    for(j=0; j<bag.length; j++)
    {
      bg = bag.charAt(j);
      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if(!chr_match)
    {
      alert('Non character integer string');
      alert('Accept only ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890. ');
      return false;
    }
  }
  return true;
}

function check_str(str)
{ 
  var i;
  var j;
  var bag = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.- ";
  var chr_match;
  var sr;
  var bg;
  for (i = 0; i < str.length; i++)
  { 
    sr = str.charAt(i);
    chr_match = false;

    for(j=0; j<bag.length; j++)
    {
      bg = bag.charAt(j);

      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if( !chr_match )
    {
      alert('No strange characters, only , ,-,A-Z,a-z,0-9');
      return false;
    }
  }
  return true;
}

function check_str_int_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (!check_str_int(str,id))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    return false;
  }
  else
  {
    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }
    return true;
  }
}

function check_str_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (!check_str(str))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    alert('Non-character string');
    return false;
  }
  else
  {
    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }
    return true;
  }
}

function check_security_str(str)
{ 
  var i;
  var j;
  var bag = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/#(){}[].,";
  var chr_match;
  var sr;
  var bg;

  for (i = 0; i < str.length; i++)
  { 
    sr = str.charAt(i);
    chr_match = false;
    for(j=0; j<bag.length; j++)
    {
      bg = bag.charAt(j);
      if ( sr == bg )
      {
          chr_match = true;
          break;
      }
    }

    if(!chr_match) return false;
  }
  return true;
}

function check_security_str_state(str,id)
{
  var theElement;
  theElement = document.getElementById(id);
  var color = theElement.style.backgroundColor;
  if (!check_security_str(str))
  {
    if(color == "cyan" || color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="pink";
    }
    if(color == "yellow" || color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="#ffc0cb";
    }
    if(color == "silver" || color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="#ffc0cc";
    }
//  theElement.focus();
//  theElement.select();
    alert('Inappropriate characters');
    return false;
  }
  else
  {
    if(color == "pink" || color == "red")
    {
      theElement.style.backgroundColor="cyan";
    }
    if(color == "#ffc0cb" || color == "#ff0000")
    {
      theElement.style.backgroundColor="yellow";
    }
    if(color == "#ffc0cc" || color == "#ff0001")
    {
    theElement.style.backgroundColor="silver";
    }
    return true;
  }
}

function win(name)
{
  Win=window.open(name,"Win",'toolbar=no,menubar=no,scrollbars=yes,resizable=yes');
  Win.window.resizeTo('1000','600');
  Win.window.focus();
}

function smwin(name)
{
  SmallWin=window.open(name,"SmallWin",'toolbar=no,menubar=no,scrollbars=yes');
  SmallWin.window.resizeTo('655','350');
  SmallWin.window.focus();
}

function check_year(year)
{
  var theElement;
  if (!check_int_state(str,id)) return false;
  var year = parseInt(str);
// range 1 day previous and 1 hour forward
  var curDate = new Date();
  var curTime = curDate.getTime();
  var preDate = new Date(curTime-86400);
  var forDate = new Date(curTime+3600);
  if (year >= preDate.getFullYear() &&
      year <= forDate.getFullYear())
  {
    return true;
  }
  return false;
}

function valid_date(year,month,day,hour,minute)
{
  var curDate = new Date();
  var curTime = curDate.getTime()
  var daTime = Date.UTC(year,month-1,day,hour,minute,0);
// Check date.  Earlier than currect and newer than 49 hours ago.
// 90000000 milliseconds = 25 hours
// 176400000 milliseconds = 49 hours
  if ((daTime < curTime) && (daTime > curTime - 176400000))
  {
    return true;
  }
//alert(year);
//alert(month-1);
//alert(day);
//alert(hour);
//alert(minute);
//alert(daTime);
//alert(curTime);
//alert(curTime/3600000 - daTime/3600000);
  if (daTime >= curTime)
  {
    alert("Date is in the future")
  }
  if (daTime <= curTime - 176400000)
  {
    alert("Date is more than 48 hours too old")
  }
  
  return false;
}

function age_date_past(year,month,day,hour,minute)
{
  var curDate = new Date();
  var daDate = new Date(year,month-1,day,hour,minute);
  var diff = (daDate - curDate)/1000/60 - curDate.getTimezoneOffset();
  if (diff > 0)
  {
    return false;  // date is in futre
  }
  return true;
}

function age_date_future(year,month,day,hour,minute)
{
  var curDate = new Date();
  var daDate = new Date(year,month-1,day,hour,minute);
  var diff = (daDate - curDate)/1000/60 - curDate.getTimezoneOffset();
  if (diff < 0)
  {
    return false;  // date is in past
  }
  return true;
}

function check_usage_survey()
{
  if(document.forms[0].rank.value == "")
  {
    alert("No rank has been submitted. Please submit");
    return false;
  }

  if(document.forms[0].name.value == "")
  {
    alert("No name has been submitted. Please submit");
    return false;
  }

  if(document.forms[0].email.value == "")
  {
    alert("No email has been submitted. Please submit");
    return false;
  }

  if(document.forms[0].site.value == "")
  {
    alert("No ship or station name has been submitted. Please submit");
    return false;
  }

  if(document.forms[0].comments.value == "")
  {
    alert("No comments have been submitted. Please submit");
    return false;
  }

}

function funct_lev_zz(value_tt,str_tt,value_zz,str_zz)
{
  if(value_zz == "" && value_tt == "") {return true;}
  var test_tt = check_tt_float_range_state(value_tt,str_tt);
  var test_zz = check_zz_float_range_state(value_zz,str_zz);

  if(value_zz == "" || !test_zz && test_tt )
  {
    var alert_str = str_zz.concat(" --- Please provide a correct value");
    alert(alert_str);
    return false;
  }
  else
  {
    return true;
  }
}


function funct_lev_tt(value_tt,str_tt,value_zz,str_zz)
{
  if(value_zz == "" && value_tt == "") {return true;}
  var test_tt = check_tt_float_range_state(value_tt,str_tt);
  var test_zz = check_zz_float_range_state(value_zz,str_zz);

  if(test_zz && !test_tt)
  {
    var alert_str = str_tt.concat(" --- Please provide a correct value");
    alert(alert_str);
    return false;
  }
  else
  {
    return true;
  }
}

//function check_data_list(data_type,clas)
function check_data_list(data_type)
{
// check BUFR form
  if(document.forms[0].submit_type.value == "bufr")
  {

    if(document.forms[0].upload_bufr_file.value == "")
    {
      alert("BUFR upload file is missing. Please submit one");
      return false;
    }

    var title = document.forms[0].title.value;
  }

// check WMO short form
  if(document.forms[0].submit_type.value == "wmo")
  {

    if(document.forms[0].upload_wmo_text.value == " ")
    {
// Bug in Portal.  Null is turned into a blank space
      document.forms[0].upload_wmo_text.value = "";
    }
    if(document.forms[0].upload_wmo_text.value == "" &&
       document.forms[0].upload_wmo_file.value == "")
    {
      alert("wmo text and wmo upload file are missing. Please submit one");
      return false;
    }

    if(document.forms[0].upload_wmo_text.value != "" &&
       document.forms[0].upload_wmo_file.value != "")
    {
      alert("wmo text and wmo upload file are both present. Please submit one");
      return false;
    }

    var title = document.forms[0].title.value;
    var wmo_id = document.forms[0].wmo_id.value.split(",");
    var wmo_id_cnt = wmo_id.length;
    var i;
    var test_pres;
    if(document.forms[0].upload_wmo_text.value != "")
    {

      // check to see if any of wmo_id's are present in message
      test_pres = "no";
      for (i=0; i<wmo_id_cnt; i++)
      {
        if(document.forms[0].upload_wmo_text.value.search(wmo_id[i]) != "-1")
        {
          test_pres = "yes";
        }
      }

      if(test_pres == "no")
      {
        alert("wmo text does not contain "+wmo_id+", please correct\nand submit as a "+title);
        return false;
      }

      // check to see if any of wmo_id's are first
      test_pres = "no";
      for (i=0; i<wmo_id_cnt; i++)
      {
        if(document.forms[0].upload_wmo_text.value.search(wmo_id[i]) == "0")
        {
          test_pres = "yes";
        }
      }

      if(test_pres == "no")
      {
        alert("wmo text does not have "+wmo_id+" at beginning, please correct\nand submit as a "+title);
        return false;
      }
    }
  }

  // check bathy long form
  var test_tt;
  var test_zz;
  if(data_type == "bathy_form")
  {
      // work in progress
      // zz0 tt0
    if(!funct_lev_zz(document.forms[0].tt0.value,"tt0",document.forms[0].zz0.value,"zz0")) { document.forms[0].zz0.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt0.value,"tt0",document.forms[0].zz0.value,"zz0")) { document.forms[0].tt0.style.backgroundColor="#ff0000"; return false; }

    // zz1 tt1
    if(!funct_lev_zz(document.forms[0].tt1.value,"tt1",document.forms[0].zz1.value,"zz1")) { document.forms[0].zz1.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt1.value,"tt1",document.forms[0].zz1.value,"zz1")) { document.forms[0].tt1.style.backgroundColor="#ff0000"; return false; }

    // zz2 tt2
    if(!funct_lev_zz(document.forms[0].tt2.value,"tt2",document.forms[0].zz2.value,"zz2")) { document.forms[0].zz2.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt2.value,"tt2",document.forms[0].zz2.value,"zz2")) { document.forms[0].tt2.style.backgroundColor="#ff0000"; return false; }

    // zz3 tt3
    if(!funct_lev_zz(document.forms[0].tt3.value,"tt3",document.forms[0].zz3.value,"zz3")) { document.forms[0].zz3.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt3.value,"tt3",document.forms[0].zz3.value,"zz3")) { document.forms[0].tt3.style.backgroundColor="#ff0000"; return false; }

    // zz4 tt4
    if(!funct_lev_zz(document.forms[0].tt4.value,"tt4",document.forms[0].zz4.value,"zz4")) { document.forms[0].zz4.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt4.value,"tt4",document.forms[0].zz4.value,"zz4")) { document.forms[0].tt4.style.backgroundColor="#ff0000"; return false; }

    // zz5 tt5
    if(!funct_lev_zz(document.forms[0].tt5.value,"tt5",document.forms[0].zz5.value,"zz5")) { document.forms[0].zz5.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt5.value,"tt5",document.forms[0].zz5.value,"zz5")) { document.forms[0].tt5.style.backgroundColor="#ff0000"; return false; }

    // zz6 tt6
    if(!funct_lev_zz(document.forms[0].tt6.value,"tt6",document.forms[0].zz6.value,"zz6")) { document.forms[0].zz6.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt6.value,"tt6",document.forms[0].zz6.value,"zz6")) { document.forms[0].tt6.style.backgroundColor="#ff0000"; return false; }

    // zz7 tt7
    if(!funct_lev_zz(document.forms[0].tt7.value,"tt7",document.forms[0].zz7.value,"zz7")) { document.forms[0].zz7.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt7.value,"tt7",document.forms[0].zz7.value,"zz7")) { document.forms[0].tt7.style.backgroundColor="#ff0000"; return false; }

    // zz8 tt8
    if(!funct_lev_zz(document.forms[0].tt8.value,"tt8",document.forms[0].zz8.value,"zz8")) { document.forms[0].zz8.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt8.value,"tt8",document.forms[0].zz8.value,"zz8")) { document.forms[0].tt8.style.backgroundColor="#ff0000"; return false; }

    // zz9 tt9
    if(!funct_lev_zz(document.forms[0].tt9.value,"tt9",document.forms[0].zz9.value,"zz9")) { document.forms[0].zz9.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt9.value,"tt9",document.forms[0].zz9.value,"zz9")) { document.forms[0].tt9.style.backgroundColor="#ff0000"; return false; }

    // zz10 tt10
    if(!funct_lev_zz(document.forms[0].tt10.value,"tt10",document.forms[0].zz10.value,"zz10")) { document.forms[0].zz10.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt10.value,"tt10",document.forms[0].zz10.value,"zz10")) { document.forms[0].tt10.style.backgroundColor="#ff0000"; return false; }

    // zz11 tt11
    if(!funct_lev_zz(document.forms[0].tt11.value,"tt11",document.forms[0].zz11.value,"zz11")) { document.forms[0].zz11.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt11.value,"tt11",document.forms[0].zz11.value,"zz11")) { document.forms[0].tt11.style.backgroundColor="#ff0000"; return false; }

    // zz12 tt12
    if(!funct_lev_zz(document.forms[0].tt12.value,"tt12",document.forms[0].zz12.value,"zz12")) { document.forms[0].zz12.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt12.value,"tt12",document.forms[0].zz12.value,"zz12")) { document.forms[0].tt12.style.backgroundColor="#ff0000"; return false; }

    // zz13 tt13
    if(!funct_lev_zz(document.forms[0].tt13.value,"tt13",document.forms[0].zz13.value,"zz13")) { document.forms[0].zz13.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt13.value,"tt13",document.forms[0].zz13.value,"zz13")) { document.forms[0].tt13.style.backgroundColor="#ff0000"; return false; }

    // zz14 tt14
    if(!funct_lev_zz(document.forms[0].tt14.value,"tt14",document.forms[0].zz14.value,"zz14")) { document.forms[0].zz14.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt14.value,"tt14",document.forms[0].zz14.value,"zz14")) { document.forms[0].tt14.style.backgroundColor="#ff0000"; return false; }

    // zz15 tt15
    if(!funct_lev_zz(document.forms[0].tt15.value,"tt15",document.forms[0].zz15.value,"zz15")) { document.forms[0].zz15.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt15.value,"tt15",document.forms[0].zz15.value,"zz15")) { document.forms[0].tt15.style.backgroundColor="#ff0000"; return false; }

    // zz16 tt16
    if(!funct_lev_zz(document.forms[0].tt16.value,"tt16",document.forms[0].zz16.value,"zz16")) { document.forms[0].zz16.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt16.value,"tt16",document.forms[0].zz16.value,"zz16")) { document.forms[0].tt16.style.backgroundColor="#ff0000"; return false; }

    // zz17 tt17
    if(!funct_lev_zz(document.forms[0].tt17.value,"tt17",document.forms[0].zz17.value,"zz17")) { document.forms[0].zz17.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt17.value,"tt17",document.forms[0].zz17.value,"zz17")) { document.forms[0].tt17.style.backgroundColor="#ff0000"; return false; }

    // zz18 tt18
    if(!funct_lev_zz(document.forms[0].tt18.value,"tt18",document.forms[0].zz18.value,"zz18")) { document.forms[0].zz18.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt18.value,"tt18",document.forms[0].zz18.value,"zz18")) { document.forms[0].tt18.style.backgroundColor="#ff0000"; return false; }

    // zz19 tt19
    if(!funct_lev_zz(document.forms[0].tt19.value,"tt19",document.forms[0].zz19.value,"zz19")) { document.forms[0].zz19.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt19.value,"tt19",document.forms[0].zz19.value,"zz19")) { document.forms[0].tt19.style.backgroundColor="#ff0000"; return false; }

    // zz20 tt20
    if(!funct_lev_zz(document.forms[0].tt20.value,"tt20",document.forms[0].zz20.value,"zz20")) { document.forms[0].zz20.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt20.value,"tt20",document.forms[0].zz20.value,"zz20")) { document.forms[0].tt20.style.backgroundColor="#ff0000"; return false; }

    // zz21 tt21
    if(!funct_lev_zz(document.forms[0].tt21.value,"tt21",document.forms[0].zz21.value,"zz21")) { document.forms[0].zz21.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt21.value,"tt21",document.forms[0].zz21.value,"zz21")) { document.forms[0].tt21.style.backgroundColor="#ff0000"; return false; }

// zz22 tt22
    if(!funct_lev_zz(document.forms[0].tt22.value,"tt22",document.forms[0].zz22.value,"zz22")) { document.forms[0].zz22.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt22.value,"tt22",document.forms[0].zz22.value,"zz22")) { document.forms[0].tt22.style.backgroundColor="#ff0000"; return false; }

// zz23 tt23
    if(!funct_lev_zz(document.forms[0].tt23.value,"tt23",document.forms[0].zz23.value,"zz23")) { document.forms[0].zz23.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt23.value,"tt23",document.forms[0].zz23.value,"zz23")) { document.forms[0].tt23.style.backgroundColor="#ff0000"; return false; }

// zz24 tt24
    if(!funct_lev_zz(document.forms[0].tt24.value,"tt24",document.forms[0].zz24.value,"zz24")) { document.forms[0].zz24.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt24.value,"tt24",document.forms[0].zz24.value,"zz24")) { document.forms[0].tt24.style.backgroundColor="#ff0000"; return false; }

    // zz25 tt25
    if(!funct_lev_zz(document.forms[0].tt25.value,"tt25",document.forms[0].zz25.value,"zz25")) { document.forms[0].zz25.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt25.value,"tt25",document.forms[0].zz25.value,"zz25")) { document.forms[0].tt25.style.backgroundColor="#ff0000"; return false; }

    // zz26 tt26
    if(!funct_lev_zz(document.forms[0].tt26.value,"tt26",document.forms[0].zz26.value,"zz26")) { document.forms[0].zz26.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt26.value,"tt26",document.forms[0].zz26.value,"zz26")) { document.forms[0].tt26.style.backgroundColor="#ff0000"; return false; }

    // zz27 tt27
    if(!funct_lev_zz(document.forms[0].tt27.value,"tt27",document.forms[0].zz27.value,"zz27")) { document.forms[0].zz27.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt27.value,"tt27",document.forms[0].zz27.value,"zz27")) { document.forms[0].tt27.style.backgroundColor="#ff0000"; return false; }

    // zz28 tt28
    if(!funct_lev_zz(document.forms[0].tt28.value,"tt28",document.forms[0].zz28.value,"zz28")) { document.forms[0].zz28.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt28.value,"tt28",document.forms[0].zz28.value,"zz28")) { document.forms[0].tt28.style.backgroundColor="#ff0000"; return false; }

    // zz29 tt29
    if(!funct_lev_zz(document.forms[0].tt29.value,"tt29",document.forms[0].zz29.value,"zz29")) { document.forms[0].zz29.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt29.value,"tt29",document.forms[0].zz29.value,"zz29")) { document.forms[0].tt29.style.backgroundColor="#ff0000"; return false; }

    // zz30 tt30
    if(!funct_lev_zz(document.forms[0].tt30.value,"tt30",document.forms[0].zz30.value,"zz30")) { document.forms[0].zz30.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt30.value,"tt30",document.forms[0].zz30.value,"zz30")) { document.forms[0].tt30.style.backgroundColor="#ff0000"; return false; }

    // zz31 tt31
    if(!funct_lev_zz(document.forms[0].tt31.value,"tt31",document.forms[0].zz31.value,"zz31")) { document.forms[0].zz31.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt31.value,"tt31",document.forms[0].zz31.value,"zz31")) { document.forms[0].tt31.style.backgroundColor="#ff0000"; return false; }

    // zz32 tt32
    if(!funct_lev_zz(document.forms[0].tt32.value,"tt32",document.forms[0].zz32.value,"zz32")) { document.forms[0].zz32.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt32.value,"tt32",document.forms[0].zz32.value,"zz32")) { document.forms[0].tt32.style.backgroundColor="#ff0000"; return false; }

    // zz33 tt33
    if(!funct_lev_zz(document.forms[0].tt33.value,"tt33",document.forms[0].zz33.value,"zz33")) { document.forms[0].zz33.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt33.value,"tt33",document.forms[0].zz33.value,"zz33")) { document.forms[0].tt33.style.backgroundColor="#ff0000"; return false; }

    // zz34 tt34
    if(!funct_lev_zz(document.forms[0].tt34.value,"tt34",document.forms[0].zz34.value,"zz34")) { document.forms[0].zz34.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt34.value,"tt34",document.forms[0].zz34.value,"zz34")) { document.forms[0].tt34.style.backgroundColor="#ff0000"; return false; }

    // zz35 tt35
    if(!funct_lev_zz(document.forms[0].tt35.value,"tt35",document.forms[0].zz35.value,"zz35")) { document.forms[0].zz35.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt35.value,"tt35",document.forms[0].zz35.value,"zz35")) { document.forms[0].tt35.style.backgroundColor="#ff0000"; return false; }

    // zz36 tt36
    if(!funct_lev_zz(document.forms[0].tt36.value,"tt36",document.forms[0].zz36.value,"zz36")) { document.forms[0].zz36.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt36.value,"tt36",document.forms[0].zz36.value,"zz36")) { document.forms[0].tt36.style.backgroundColor="#ff0000"; return false; }

    // zz37 tt37
    if(!funct_lev_zz(document.forms[0].tt37.value,"tt37",document.forms[0].zz37.value,"zz37")) { document.forms[0].zz37.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt37.value,"tt37",document.forms[0].zz37.value,"zz37")) { document.forms[0].tt37.style.backgroundColor="#ff0000"; return false; }

    // zz38 tt38
    if(!funct_lev_zz(document.forms[0].tt38.value,"tt38",document.forms[0].zz38.value,"zz38")) { document.forms[0].zz38.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt48.value,"tt38",document.forms[0].zz38.value,"zz38")) { document.forms[0].tt38.style.backgroundColor="#ff0000"; return false; }

    // zz39 tt39
    if(!funct_lev_zz(document.forms[0].tt29.value,"tt39",document.forms[0].zz39.value,"zz39")) { document.forms[0].zz39.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt29.value,"tt39",document.forms[0].zz39.value,"zz39")) { document.forms[0].tt39.style.backgroundColor="#ff0000"; return false; }

    // zz40 tt40
    if(!funct_lev_zz(document.forms[0].tt40.value,"tt40",document.forms[0].zz40.value,"zz40")) { document.forms[0].zz40.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt40.value,"tt40",document.forms[0].zz40.value,"zz40")) { document.forms[0].tt40.style.backgroundColor="#ff0000"; return false; }

    // zz41 tt41
    if(!funct_lev_zz(document.forms[0].tt41.value,"tt41",document.forms[0].zz41.value,"zz41")) { document.forms[0].zz41.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt41.value,"tt41",document.forms[0].zz41.value,"zz41")) { document.forms[0].tt41.style.backgroundColor="#ff0000"; return false; }

    // zz42 tt42
    if(!funct_lev_zz(document.forms[0].tt42.value,"tt42",document.forms[0].zz42.value,"zz42")) { document.forms[0].zz42.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt42.value,"tt42",document.forms[0].zz42.value,"zz42")) { document.forms[0].tt42.style.backgroundColor="#ff0000"; return false; }

    // zz43 tt43
    if(!funct_lev_zz(document.forms[0].tt43.value,"tt43",document.forms[0].zz43.value,"zz43")) { document.forms[0].zz43.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt43.value,"tt43",document.forms[0].zz43.value,"zz43")) { document.forms[0].tt43.style.backgroundColor="#ff0000"; return false; }

    // zz44 tt44
    if(!funct_lev_zz(document.forms[0].tt44.value,"tt44",document.forms[0].zz44.value,"zz44")) { document.forms[0].zz44.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt44.value,"tt44",document.forms[0].zz44.value,"zz44")) { document.forms[0].tt44.style.backgroundColor="#ff0000"; return false; }

    // zz45 tt45
    if(!funct_lev_zz(document.forms[0].tt45.value,"tt45",document.forms[0].zz45.value,"zz45")) { document.forms[0].zz45.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt45.value,"tt45",document.forms[0].zz45.value,"zz45")) { document.forms[0].tt45.style.backgroundColor="#ff0000"; return false; }

    // zz46 tt46
    if(!funct_lev_zz(document.forms[0].tt46.value,"tt46",document.forms[0].zz46.value,"zz46")) { document.forms[0].zz46.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt46.value,"tt46",document.forms[0].zz46.value,"zz46")) { document.forms[0].tt46.style.backgroundColor="#ff0000"; return false; }

    // zz47 tt47
    if(!funct_lev_zz(document.forms[0].tt47.value,"tt47",document.forms[0].zz47.value,"zz47")) { document.forms[0].zz47.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt47.value,"tt47",document.forms[0].zz47.value,"zz47")) { document.forms[0].tt47.style.backgroundColor="#ff0000"; return false; }

    // zz48 tt48
    if(!funct_lev_zz(document.forms[0].tt48.value,"tt48",document.forms[0].zz48.value,"zz48")) { document.forms[0].zz48.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt48.value,"tt48",document.forms[0].zz48.value,"zz48")) { document.forms[0].tt48.style.backgroundColor="#ff0000"; return false; }

    // zz49 tt49
    if(!funct_lev_zz(document.forms[0].tt49.value,"tt49",document.forms[0].zz49.value,"zz49")) { document.forms[0].zz49.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt49.value,"tt49",document.forms[0].zz49.value,"zz49")) { document.forms[0].tt49.style.backgroundColor="#ff0000"; return false; }

    // zz50 tt50
    if(!funct_lev_zz(document.forms[0].tt50.value,"tt50",document.forms[0].zz50.value,"zz50")) { document.forms[0].zz50.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt50.value,"tt50",document.forms[0].zz50.value,"zz50")) { document.forms[0].tt50.style.backgroundColor="#ff0000"; return false; }

    // zz51 tt51
    if(!funct_lev_zz(document.forms[0].tt51.value,"tt51",document.forms[0].zz51.value,"zz51")) { document.forms[0].zz51.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt51.value,"tt51",document.forms[0].zz51.value,"zz51")) { document.forms[0].tt51.style.backgroundColor="#ff0000"; return false; }

    // zz52 tt52
    if(!funct_lev_zz(document.forms[0].tt52.value,"tt52",document.forms[0].zz52.value,"zz52")) { document.forms[0].zz52.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt52.value,"tt52",document.forms[0].zz52.value,"zz52")) { document.forms[0].tt52.style.backgroundColor="#ff0000"; return false; }

    // zz53 tt53
    if(!funct_lev_zz(document.forms[0].tt53.value,"tt53",document.forms[0].zz53.value,"zz53")) { document.forms[0].zz53.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt53.value,"tt53",document.forms[0].zz53.value,"zz53")) { document.forms[0].tt53.style.backgroundColor="#ff0000"; return false; }

    // zz54 tt54
    if(!funct_lev_zz(document.forms[0].tt54.value,"tt54",document.forms[0].zz54.value,"zz54")) { document.forms[0].zz54.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt54.value,"tt54",document.forms[0].zz54.value,"zz54")) { document.forms[0].tt54.style.backgroundColor="#ff0000"; return false; }

    // zz55 tt55
    if(!funct_lev_zz(document.forms[0].tt55.value,"tt55",document.forms[0].zz55.value,"zz55")) { document.forms[0].zz55.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt55.value,"tt55",document.forms[0].zz55.value,"zz55")) { document.forms[0].tt55.style.backgroundColor="#ff0000"; return false; }

    // zz56 tt56
    if(!funct_lev_zz(document.forms[0].tt56.value,"tt56",document.forms[0].zz56.value,"zz56")) { document.forms[0].zz56.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt56.value,"tt56",document.forms[0].zz56.value,"zz56")) { document.forms[0].tt56.style.backgroundColor="#ff0000"; return false; }

    // zz57 tt57
    if(!funct_lev_zz(document.forms[0].tt57.value,"tt57",document.forms[0].zz57.value,"zz57")) { document.forms[0].zz57.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt57.value,"tt57",document.forms[0].zz57.value,"zz57")) { document.forms[0].tt57.style.backgroundColor="#ff0000"; return false; }

    // zz58 tt58
    if(!funct_lev_zz(document.forms[0].tt58.value,"tt58",document.forms[0].zz58.value,"zz58")) { document.forms[0].zz58.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt58.value,"tt58",document.forms[0].zz58.value,"zz58")) { document.forms[0].tt58.style.backgroundColor="#ff0000"; return false; }

    // zz59 tt59
    if(!funct_lev_zz(document.forms[0].tt59.value,"tt59",document.forms[0].zz59.value,"zz59")) { document.forms[0].zz59.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt59.value,"tt59",document.forms[0].zz59.value,"zz59")) { document.forms[0].tt59.style.backgroundColor="#ff0000"; return false; }

    // zz60 tt60
    if(!funct_lev_zz(document.forms[0].tt60.value,"tt60",document.forms[0].zz60.value,"zz60")) { document.forms[0].zz60.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt60.value,"tt60",document.forms[0].zz60.value,"zz60")) { document.forms[0].tt60.style.backgroundColor="#ff0000"; return false; }

    // zz61 tt61
    if(!funct_lev_zz(document.forms[0].tt61.value,"tt61",document.forms[0].zz61.value,"zz61")) { document.forms[0].zz61.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt61.value,"tt61",document.forms[0].zz61.value,"zz61")) { document.forms[0].tt61.style.backgroundColor="#ff0000"; return false; }

    // zz62 tt62
    if(!funct_lev_zz(document.forms[0].tt62.value,"tt62",document.forms[0].zz62.value,"zz62")) { document.forms[0].zz62.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt62.value,"tt62",document.forms[0].zz62.value,"zz62")) { document.forms[0].tt62.style.backgroundColor="#ff0000"; return false; }

    // zz63 tt63
    if(!funct_lev_zz(document.forms[0].tt63.value,"tt63",document.forms[0].zz63.value,"zz63")) { document.forms[0].zz63.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt63.value,"tt63",document.forms[0].zz63.value,"zz63")) { document.forms[0].tt63.style.backgroundColor="#ff0000"; return false; }

// zz64 tt64
    if(!funct_lev_zz(document.forms[0].tt64.value,"tt64",document.forms[0].zz64.value,"zz64")) { document.forms[0].zz64.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt64.value,"tt64",document.forms[0].zz64.value,"zz64")) { document.forms[0].tt64.style.backgroundColor="#ff0000"; return false; }

    // zz65 tt65
    if(!funct_lev_zz(document.forms[0].tt65.value,"tt65",document.forms[0].zz65.value,"zz65")) { document.forms[0].zz65.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt65.value,"tt65",document.forms[0].zz65.value,"zz65")) { document.forms[0].tt65.style.backgroundColor="#ff0000"; return false; }

    // zz66 tt66
    if(!funct_lev_zz(document.forms[0].tt66.value,"tt66",document.forms[0].zz66.value,"zz66")) { document.forms[0].zz66.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt66.value,"tt66",document.forms[0].zz66.value,"zz66")) { document.forms[0].tt66.style.backgroundColor="#ff0000"; return false; }

    // zz67 tt67
    if(!funct_lev_zz(document.forms[0].tt67.value,"tt67",document.forms[0].zz67.value,"zz67")) { document.forms[0].zz67.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt67.value,"tt67",document.forms[0].zz67.value,"zz67")) { document.forms[0].tt67.style.backgroundColor="#ff0000"; return false; }

    // zz68 tt68
    if(!funct_lev_zz(document.forms[0].tt68.value,"tt68",document.forms[0].zz68.value,"zz68")) { document.forms[0].zz68.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt68.value,"tt68",document.forms[0].zz68.value,"zz68")) { document.forms[0].tt68.style.backgroundColor="#ff0000"; return false; }

    // zz69 tt69
    if(!funct_lev_zz(document.forms[0].tt69.value,"tt69",document.forms[0].zz69.value,"zz69")) { document.forms[0].zz69.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt69.value,"tt69",document.forms[0].zz69.value,"zz69")) { document.forms[0].tt69.style.backgroundColor="#ff0000"; return false; }

    // zz70 tt70
    if(!funct_lev_zz(document.forms[0].tt70.value,"tt70",document.forms[0].zz70.value,"zz70")) { document.forms[0].zz70.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt70.value,"tt70",document.forms[0].zz70.value,"zz70")) { document.forms[0].tt70.style.backgroundColor="#ff0000"; return false; }

    // zz71 tt71
    if(!funct_lev_zz(document.forms[0].tt71.value,"tt71",document.forms[0].zz71.value,"zz71")) { document.forms[0].zz71.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt71.value,"tt71",document.forms[0].zz71.value,"zz71")) { document.forms[0].tt71.style.backgroundColor="#ff0000"; return false; }

    // zz72 tt72
    if(!funct_lev_zz(document.forms[0].tt72.value,"tt72",document.forms[0].zz72.value,"zz72")) { document.forms[0].zz72.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt72.value,"tt72",document.forms[0].zz72.value,"zz72")) { document.forms[0].tt72.style.backgroundColor="#ff0000"; return false; }

    // zz73 tt73
    if(!funct_lev_zz(document.forms[0].tt73.value,"tt73",document.forms[0].zz73.value,"zz73")) { document.forms[0].zz73.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt73.value,"tt73",document.forms[0].zz73.value,"zz73")) { document.forms[0].tt73.style.backgroundColor="#ff0000"; return false; }

    // zz74 tt74
    if(!funct_lev_zz(document.forms[0].tt74.value,"tt74",document.forms[0].zz74.value,"zz74")) { document.forms[0].zz74.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt74.value,"tt74",document.forms[0].zz74.value,"zz74")) { document.forms[0].tt74.style.backgroundColor="#ff0000"; return false; }

    // zz75 tt75
    if(!funct_lev_zz(document.forms[0].tt75.value,"tt75",document.forms[0].zz75.value,"zz75")) { document.forms[0].zz75.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt75.value,"tt75",document.forms[0].zz75.value,"zz75")) { document.forms[0].tt75.style.backgroundColor="#ff0000"; return false; }

    // zz76 tt76
    if(!funct_lev_zz(document.forms[0].tt76.value,"tt76",document.forms[0].zz76.value,"zz76")) { document.forms[0].zz76.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt76.value,"tt76",document.forms[0].zz76.value,"zz76")) { document.forms[0].tt76.style.backgroundColor="#ff0000"; return false; }

    // zz77 tt77
    if(!funct_lev_zz(document.forms[0].tt77.value,"tt77",document.forms[0].zz77.value,"zz77")) { document.forms[0].zz77.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt77.value,"tt77",document.forms[0].zz77.value,"zz77")) { document.forms[0].tt77.style.backgroundColor="#ff0000"; return false; }

    // zz78 tt78
    if(!funct_lev_zz(document.forms[0].tt78.value,"tt78",document.forms[0].zz78.value,"zz78")) { document.forms[0].zz78.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt78.value,"tt78",document.forms[0].zz78.value,"zz78")) { document.forms[0].tt78.style.backgroundColor="#ff0000"; return false; }

    // zz79 tt79
    if(!funct_lev_zz(document.forms[0].tt79.value,"tt79",document.forms[0].zz79.value,"zz79")) { document.forms[0].zz79.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt79.value,"tt79",document.forms[0].zz79.value,"zz79")) { document.forms[0].tt79.style.backgroundColor="#ff0000"; return false; }

    // zz80 tt80
    if(!funct_lev_zz(document.forms[0].tt80.value,"tt80",document.forms[0].zz80.value,"zz80")) { document.forms[0].zz80.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt80.value,"tt80",document.forms[0].zz80.value,"zz80")) { document.forms[0].tt80.style.backgroundColor="#ff0000"; return false; }

    // zz81 tt81
    if(!funct_lev_zz(document.forms[0].tt81.value,"tt81",document.forms[0].zz81.value,"zz81")) { document.forms[0].zz81.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt81.value,"tt81",document.forms[0].zz81.value,"zz81")) { document.forms[0].tt81.style.backgroundColor="#ff0000"; return false; }

    // zz82 tt82
    if(!funct_lev_zz(document.forms[0].tt82.value,"tt82",document.forms[0].zz82.value,"zz82")) { document.forms[0].zz82.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt82.value,"tt82",document.forms[0].zz82.value,"zz82")) { document.forms[0].tt82.style.backgroundColor="#ff0000"; return false; }

    // zz83 tt83
    if(!funct_lev_zz(document.forms[0].tt83.value,"tt83",document.forms[0].zz83.value,"zz83")) { document.forms[0].zz83.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt83.value,"tt83",document.forms[0].zz83.value,"zz83")) { document.forms[0].tt83.style.backgroundColor="#ff0000"; return false; }

    // zz84 tt84
    if(!funct_lev_zz(document.forms[0].tt84.value,"tt84",document.forms[0].zz84.value,"zz84")) { document.forms[0].zz84.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt84.value,"tt84",document.forms[0].zz84.value,"zz84")) { document.forms[0].tt84.style.backgroundColor="#ff0000"; return false; }

    // zz85 tt85
    if(!funct_lev_zz(document.forms[0].tt85.value,"tt85",document.forms[0].zz85.value,"zz85")) { document.forms[0].zz85.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt85.value,"tt85",document.forms[0].zz85.value,"zz85")) { document.forms[0].tt85.style.backgroundColor="#ff0000"; return false; }

    // zz86 tt86
    if(!funct_lev_zz(document.forms[0].tt86.value,"tt86",document.forms[0].zz86.value,"zz86")) { document.forms[0].zz86.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt86.value,"tt86",document.forms[0].zz86.value,"zz86")) { document.forms[0].tt86.style.backgroundColor="#ff0000"; return false; }

    // zz87 tt87
    if(!funct_lev_zz(document.forms[0].tt87.value,"tt87",document.forms[0].zz87.value,"zz87")) { document.forms[0].zz87.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt87.value,"tt87",document.forms[0].zz87.value,"zz87")) { document.forms[0].tt87.style.backgroundColor="#ff0000"; return false; }

    // zz88 tt88
    if(!funct_lev_zz(document.forms[0].tt88.value,"tt88",document.forms[0].zz88.value,"zz88")) { document.forms[0].zz88.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt88.value,"tt88",document.forms[0].zz88.value,"zz88")) { document.forms[0].tt88.style.backgroundColor="#ff0000"; return false; }

    // zz89 tt89
    if(!funct_lev_zz(document.forms[0].tt89.value,"tt89",document.forms[0].zz89.value,"zz89")) { document.forms[0].zz89.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt89.value,"tt89",document.forms[0].zz89.value,"zz89")) { document.forms[0].tt89.style.backgroundColor="#ff0000"; return false; }

    // zz90 tt90
    if(!funct_lev_zz(document.forms[0].tt90.value,"tt90",document.forms[0].zz90.value,"zz90")) { document.forms[0].zz90.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt90.value,"tt90",document.forms[0].zz90.value,"zz90")) { document.forms[0].tt90.style.backgroundColor="#ff0000"; return false; }

    // zz91 tt91
    if(!funct_lev_zz(document.forms[0].tt91.value,"tt91",document.forms[0].zz91.value,"zz91")) { document.forms[0].zz91.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt91.value,"tt91",document.forms[0].zz91.value,"zz91")) { document.forms[0].tt91.style.backgroundColor="#ff0000"; return false; }

    // zz92 tt92
    if(!funct_lev_zz(document.forms[0].tt92.value,"tt92",document.forms[0].zz92.value,"zz92")) { document.forms[0].zz92.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt92.value,"tt92",document.forms[0].zz92.value,"zz92")) { document.forms[0].tt92.style.backgroundColor="#ff0000"; return false; }

    // zz93 tt93
    if(!funct_lev_zz(document.forms[0].tt93.value,"tt93",document.forms[0].zz93.value,"zz93")) { document.forms[0].zz93.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt93.value,"tt93",document.forms[0].zz93.value,"zz93")) { document.forms[0].tt93.style.backgroundColor="#ff0000"; return false; }

    // zz94 tt94
    if(!funct_lev_zz(document.forms[0].tt94.value,"tt94",document.forms[0].zz94.value,"zz94")) { document.forms[0].zz94.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt94.value,"tt94",document.forms[0].zz94.value,"zz94")) { document.forms[0].tt94.style.backgroundColor="#ff0000"; return false; }

    // zz95 tt95
    if(!funct_lev_zz(document.forms[0].tt95.value,"tt95",document.forms[0].zz95.value,"zz95")) { document.forms[0].zz95.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt95.value,"tt95",document.forms[0].zz95.value,"zz95")) { document.forms[0].tt95.style.backgroundColor="#ff0000"; return false; }

    // zz96 tt96
    if(!funct_lev_zz(document.forms[0].tt96.value,"tt96",document.forms[0].zz96.value,"zz96")) { document.forms[0].zz96.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt96.value,"tt96",document.forms[0].zz96.value,"zz96")) { document.forms[0].tt96.style.backgroundColor="#ff0000"; return false; }

    // zz97 tt97
    if(!funct_lev_zz(document.forms[0].tt97.value,"tt97",document.forms[0].zz97.value,"zz97")) { document.forms[0].zz97.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt97.value,"tt97",document.forms[0].zz97.value,"zz97")) { document.forms[0].tt97.style.backgroundColor="#ff0000"; return false; }

    // zz98 tt98
    if(!funct_lev_zz(document.forms[0].tt98.value,"tt98",document.forms[0].zz98.value,"zz98")) { document.forms[0].zz98.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt98.value,"tt98",document.forms[0].zz98.value,"zz98")) { document.forms[0].tt98.style.backgroundColor="#ff0000"; return false; }

    // zz99 tt99
    if(!funct_lev_zz(document.forms[0].tt99.value,"tt99",document.forms[0].zz99.value,"zz99")) { document.forms[0].zz99.style.backgroundColor="#ff0000"; return false; }
    if(!funct_lev_tt(document.forms[0].tt99.value,"tt99",document.forms[0].zz99.value,"zz99")) { document.forms[0].tt99.style.backgroundColor="#ff0000"; return false; }


    // check out for of place depts

    if(document.forms[0].zz1.value != "" && document.forms[0].zz2.value !="")
    {
      if(parseFloat(document.forms[0].zz1.value) > parseFloat(document.forms[0].zz2.value))
      {
        document.forms[0].zz1.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz2.value != "" && document.forms[0].zz3.value !="")
    {
       if(parseFloat(document.forms[0].zz2.value) > parseFloat(document.forms[0].zz3.value))
      {
        document.forms[0].zz2.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz3.value != "" && document.forms[0].zz4.value !="")
    {
       if(parseFloat(document.forms[0].zz3.value) > parseFloat(document.forms[0].zz4.value))
      {
        document.forms[0].zz3.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz5.value != "" && document.forms[0].zz6.value !="")
    {
      if(parseFloat(document.forms[0].zz5.value) > parseFloat(document.forms[0].zz6.value))
      {
        document.forms[0].zz5.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz6.value != "" && document.forms[0].zz7.value !="")
    {
      if(parseFloat(document.forms[0].zz6.value) > parseFloat(document.forms[0].zz7.value))
      {
        document.forms[0].zz6.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz7.value != "" && document.forms[0].zz8.value !="")
    {
      if(parseFloat(document.forms[0].zz7.value) > parseFloat(document.forms[0].zz8.value))
      {
        document.forms[0].zz7.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz8.value != "" && document.forms[0].zz9.value !="")
    {
      if(parseFloat(document.forms[0].zz8.value) > parseFloat(document.forms[0].zz9.value))
      {
        document.forms[0].zz8.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz9.value != "" && document.forms[0].zz10.value !="")
    {
      if(parseFloat(document.forms[0].zz9.value) > parseFloat(document.forms[0].zz10.value))
      {
        document.forms[0].zz9.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz10.value != "" && document.forms[0].zz11.value !="")
    {
      if(parseFloat(document.forms[0].zz10.value) > parseFloat(document.forms[0].zz11.value))
      {
        document.forms[0].zz11.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz11.value != "" && document.forms[0].zz12.value !="")
    {
      if(parseFloat(document.forms[0].zz11.value) > parseFloat(document.forms[0].zz12.value))
      {
        document.forms[0].zz11.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz12.value != "" && document.forms[0].zz13.value !="")
    {
      if(parseFloat(document.forms[0].zz12.value) > parseFloat(document.forms[0].zz13.value))
      {
        document.forms[0].zz12.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz13.value != "" && document.forms[0].zz14.value !="")
    {
      if(parseFloat(document.forms[0].zz13.value) > parseFloat(document.forms[0].zz14.value))
      {
        document.forms[0].zz13.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz14.value != "" && document.forms[0].zz15.value !="")
    {
      if(parseFloat(document.forms[0].zz14.value) > parseFloat(document.forms[0].zz15.value))
      {
        document.forms[0].zz14.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz15.value != "" && document.forms[0].zz16.value !="")
    {
      if(parseFloat(document.forms[0].zz15.value) > parseFloat(document.forms[0].zz16.value))
      {
        document.forms[0].zz15.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz16.value != "" && document.forms[0].zz17.value !="")
    {
      if(parseFloat(document.forms[0].zz16.value) > parseFloat(document.forms[0].zz17.value))
      {
        document.forms[0].zz16.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz17.value != "" && document.forms[0].zz18.value !="")
    {
      if(parseFloat(document.forms[0].zz17.value) > parseFloat(document.forms[0].zz18.value))
      {
        document.forms[0].zz17.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz18.value != "" && document.forms[0].zz19.value !="")
    {
      if(parseFloat(document.forms[0].zz18.value) > parseFloat(document.forms[0].zz19.value))
      {
        document.forms[0].zz18.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz19.value != "" && document.forms[0].zz20.value !="")
    {
      if(parseFloat(document.forms[0].zz19.value) > parseFloat(document.forms[0].zz20.value))
      {
        document.forms[0].zz19.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz20.value != "" && document.forms[0].zz21.value !="")
    {
      if(parseFloat(document.forms[0].zz20.value) > parseFloat(document.forms[0].zz21.value))
      {
        document.forms[0].zz21.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz21.value != "" && document.forms[0].zz22.value !="")
    {
      if(parseFloat(document.forms[0].zz21.value) > parseFloat(document.forms[0].zz22.value))
      {
        document.forms[0].zz21.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz22.value != "" && document.forms[0].zz23.value !="")
    {
      if(parseFloat(document.forms[0].zz22.value) > parseFloat(document.forms[0].zz23.value))
      {
        document.forms[0].zz22.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz23.value != "" && document.forms[0].zz24.value !="")
    {
      if(parseFloat(document.forms[0].zz23.value) > parseFloat(document.forms[0].zz24.value))
      {
        document.forms[0].zz23.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz24.value != "" && document.forms[0].zz25.value !="")
    {
      if(parseFloat(document.forms[0].zz24.value) > parseFloat(document.forms[0].zz25.value))
      {
        document.forms[0].zz24.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz25.value != "" && document.forms[0].zz26.value !="")
    {
      if(parseFloat(document.forms[0].zz25.value) > parseFloat(document.forms[0].zz26.value))
      {
        document.forms[0].zz25.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz26.value != "" && document.forms[0].zz27.value !="")
    {
      if(parseFloat(document.forms[0].zz26.value) > parseFloat(document.forms[0].zz27.value))
      {
        document.forms[0].zz26.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz27.value != "" && document.forms[0].zz28.value !="")
    {
      if(parseFloat(document.forms[0].zz27.value) > parseFloat(document.forms[0].zz28.value))
      {
        document.forms[0].zz27.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz28.value != "" && document.forms[0].zz29.value !="")
    {
      if(parseFloat(document.forms[0].zz28.value) > parseFloat(document.forms[0].zz29.value))
      {
        document.forms[0].zz28.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz29.value != "" && document.forms[0].zz30.value !="")
    {
      if(parseFloat(document.forms[0].zz29.value) > parseFloat(document.forms[0].zz30.value))
      {
        document.forms[0].zz29.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz30.value != "" && document.forms[0].zz31.value !="")
    {
      if(parseFloat(document.forms[0].zz30.value) > parseFloat(document.forms[0].zz31.value))
      {
        document.forms[0].zz31.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz31.value != "" && document.forms[0].zz32.value !="")
    {
      if(parseFloat(document.forms[0].zz31.value) > parseFloat(document.forms[0].zz32.value))
      {
        document.forms[0].zz31.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz32.value != "" && document.forms[0].zz33.value !="")
    {
      if(parseFloat(document.forms[0].zz32.value) > parseFloat(document.forms[0].zz33.value))
      {
        document.forms[0].zz32.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz33.value != "" && document.forms[0].zz34.value !="")
    {
      if(parseFloat(document.forms[0].zz33.value) > parseFloat(document.forms[0].zz34.value))
      {
        document.forms[0].zz33.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz34.value != "" && document.forms[0].zz35.value !="")
    {
      if(parseFloat(document.forms[0].zz34.value) > parseFloat(document.forms[0].zz35.value))
      {
        document.forms[0].zz34.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz35.value != "" && document.forms[0].zz36.value !="")
    {
      if(parseFloat(document.forms[0].zz35.value) > parseFloat(document.forms[0].zz36.value))
      {
        document.forms[0].zz35.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz36.value != "" && document.forms[0].zz37.value !="")
    {
      if(parseFloat(document.forms[0].zz36.value) > parseFloat(document.forms[0].zz37.value))
      {
        document.forms[0].zz36.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz37.value != "" && document.forms[0].zz38.value !="")
    {
      if(parseFloat(document.forms[0].zz37.value) > parseFloat(document.forms[0].zz38.value))
      {
        document.forms[0].zz37.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz38.value != "" && document.forms[0].zz39.value !="")
    {
      if(parseFloat(document.forms[0].zz38.value) > parseFloat(document.forms[0].zz39.value))
      {
        document.forms[0].zz38.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz39.value != "" && document.forms[0].zz40.value !="")
    {
      if(parseFloat(document.forms[0].zz39.value) > parseFloat(document.forms[0].zz40.value))
      {
        document.forms[0].zz39.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz40.value != "" && document.forms[0].zz41.value !="")
    {
      if(parseFloat(document.forms[0].zz40.value) > parseFloat(document.forms[0].zz41.value))
      {
        document.forms[0].zz41.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz41.value != "" && document.forms[0].zz42.value !="")
    {
      if(parseFloat(document.forms[0].zz41.value) > parseFloat(document.forms[0].zz42.value))
      {
        document.forms[0].zz41.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz42.value != "" && document.forms[0].zz43.value !="")
    {
      if(parseFloat(document.forms[0].zz42.value) > parseFloat(document.forms[0].zz43.value))
      {
        document.forms[0].zz42.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz43.value != "" && document.forms[0].zz44.value !="")
    {
      if(parseFloat(document.forms[0].zz43.value) > parseFloat(document.forms[0].zz44.value))
      {
        document.forms[0].zz43.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz44.value != "" && document.forms[0].zz45.value !="")
    {
      if(parseFloat(document.forms[0].zz44.value) > parseFloat(document.forms[0].zz45.value))
      {
        document.forms[0].zz44.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz45.value != "" && document.forms[0].zz46.value !="")
    {
      if(parseFloat(document.forms[0].zz45.value) > parseFloat(document.forms[0].zz46.value))
      {
        document.forms[0].zz45.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz46.value != "" && document.forms[0].zz47.value !="")
    {
      if(parseFloat(document.forms[0].zz46.value) > parseFloat(document.forms[0].zz47.value))
      {
        document.forms[0].zz46.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz47.value != "" && document.forms[0].zz48.value !="")
    {
      if(parseFloat(document.forms[0].zz47.value) > parseFloat(document.forms[0].zz48.value))
      {
        document.forms[0].zz47.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz48.value != "" && document.forms[0].zz49.value !="")
    {
      if(parseFloat(document.forms[0].zz48.value) > parseFloat(document.forms[0].zz49.value))
      {
        document.forms[0].zz48.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz49.value != "" && document.forms[0].zz50.value !="")
    {
      if(parseFloat(document.forms[0].zz49.value) > parseFloat(document.forms[0].zz50.value))
      {
        document.forms[0].zz49.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz50.value != "" && document.forms[0].zz51.value !="")
    {
      if(parseFloat(document.forms[0].zz50.value) > parseFloat(document.forms[0].zz51.value))
      {
        document.forms[0].zz51.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz51.value != "" && document.forms[0].zz52.value !="")
    {
      if(parseFloat(document.forms[0].zz51.value) > parseFloat(document.forms[0].zz52.value))
      {
        document.forms[0].zz51.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz52.value != "" && document.forms[0].zz53.value !="")
    {
      if(parseFloat(document.forms[0].zz52.value) > parseFloat(document.forms[0].zz53.value))
      {
        document.forms[0].zz52.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz53.value != "" && document.forms[0].zz54.value !="")
    {
      if(parseFloat(document.forms[0].zz53.value) > parseFloat(document.forms[0].zz54.value))
      {
        document.forms[0].zz53.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz54.value != "" && document.forms[0].zz55.value !="")
    {
      if(parseFloat(document.forms[0].zz54.value) > parseFloat(document.forms[0].zz55.value))
      {
        document.forms[0].zz54.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz55.value != "" && document.forms[0].zz56.value !="")
    {
      if(parseFloat(document.forms[0].zz55.value) > parseFloat(document.forms[0].zz56.value))
      {
        document.forms[0].zz55.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz56.value != "" && document.forms[0].zz57.value !="")
    {
      if(parseFloat(document.forms[0].zz56.value) > parseFloat(document.forms[0].zz57.value))
      {
        document.forms[0].zz56.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz57.value != "" && document.forms[0].zz58.value !="")
    {
      if(parseFloat(document.forms[0].zz57.value) > parseFloat(document.forms[0].zz58.value))
      {
        document.forms[0].zz57.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz58.value != "" && document.forms[0].zz59.value !="")
    {
      if(parseFloat(document.forms[0].zz58.value) > parseFloat(document.forms[0].zz59.value))
      {
        document.forms[0].zz58.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz59.value != "" && document.forms[0].zz60.value !="")
    {
      if(parseFloat(document.forms[0].zz59.value) > parseFloat(document.forms[0].zz60.value))
      {
        document.forms[0].zz59.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz60.value != "" && document.forms[0].zz61.value !="")
    {
      if(parseFloat(document.forms[0].zz60.value) > parseFloat(document.forms[0].zz61.value))
      {
        document.forms[0].zz61.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz61.value != "" && document.forms[0].zz62.value !="")
    {
      if(parseFloat(document.forms[0].zz61.value) > parseFloat(document.forms[0].zz62.value))
      {
        document.forms[0].zz61.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz62.value != "" && document.forms[0].zz63.value !="")
    {
      if(parseFloat(document.forms[0].zz62.value) > parseFloat(document.forms[0].zz63.value))
      {
        document.forms[0].zz62.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz63.value != "" && document.forms[0].zz64.value !="")
    {
      if(parseFloat(document.forms[0].zz63.value) > parseFloat(document.forms[0].zz64.value))
      {
        document.forms[0].zz63.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz64.value != "" && document.forms[0].zz65.value !="")
    {
      if(parseFloat(document.forms[0].zz64.value) > parseFloat(document.forms[0].zz65.value))
      {
        document.forms[0].zz64.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz65.value != "" && document.forms[0].zz66.value !="")
    {
      if(parseFloat(document.forms[0].zz65.value) > parseFloat(document.forms[0].zz66.value))
      {
        document.forms[0].zz65.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz66.value != "" && document.forms[0].zz67.value !="")
    {
      if(parseFloat(document.forms[0].zz66.value) > parseFloat(document.forms[0].zz67.value))
      {
        document.forms[0].zz66.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz67.value != "" && document.forms[0].zz68.value !="")
    {
      if(parseFloat(document.forms[0].zz67.value) > parseFloat(document.forms[0].zz68.value))
      {
        document.forms[0].zz67.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz68.value != "" && document.forms[0].zz69.value !="")
    {
      if(parseFloat(document.forms[0].zz68.value) > parseFloat(document.forms[0].zz69.value))
      {
        document.forms[0].zz68.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz69.value != "" && document.forms[0].zz70.value !="")
    {
      if(parseFloat(document.forms[0].zz69.value) > parseFloat(document.forms[0].zz70.value))
      {
        document.forms[0].zz69.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz70.value != "" && document.forms[0].zz71.value !="")
    {
      if(parseFloat(document.forms[0].zz70.value) > parseFloat(document.forms[0].zz71.value))
      {
        document.forms[0].zz71.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz71.value != "" && document.forms[0].zz72.value !="")
    {
      if(parseFloat(document.forms[0].zz71.value) > parseFloat(document.forms[0].zz72.value))
      {
        document.forms[0].zz71.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz72.value != "" && document.forms[0].zz73.value !="")
    {
      if(parseFloat(document.forms[0].zz72.value) > parseFloat(document.forms[0].zz73.value))
      {
        document.forms[0].zz72.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz73.value != "" && document.forms[0].zz74.value !="")
    {
      if(parseFloat(document.forms[0].zz73.value) > parseFloat(document.forms[0].zz74.value))
      {
        document.forms[0].zz73.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz74.value != "" && document.forms[0].zz75.value !="")
    {
      if(parseFloat(document.forms[0].zz74.value) > parseFloat(document.forms[0].zz75.value))
      {
        document.forms[0].zz74.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz75.value != "" && document.forms[0].zz76.value !="")
    {
      if(parseFloat(document.forms[0].zz75.value) > parseFloat(document.forms[0].zz76.value))
      {
        document.forms[0].zz75.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz76.value != "" && document.forms[0].zz77.value !="")
    {
      if(parseFloat(document.forms[0].zz76.value) > parseFloat(document.forms[0].zz77.value))
      {
        document.forms[0].zz76.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz77.value != "" && document.forms[0].zz78.value !="")
    {
      if(parseFloat(document.forms[0].zz77.value) > parseFloat(document.forms[0].zz78.value))
      {
        document.forms[0].zz77.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz78.value != "" && document.forms[0].zz79.value !="")
    {
      if(parseFloat(document.forms[0].zz78.value) > parseFloat(document.forms[0].zz79.value))
      {
        document.forms[0].zz78.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz79.value != "" && document.forms[0].zz80.value !="")
    {
      if(parseFloat(document.forms[0].zz79.value) > parseFloat(document.forms[0].zz80.value))
      {
        document.forms[0].zz79.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz80.value != "" && document.forms[0].zz81.value !="")
    {
      if(parseFloat(document.forms[0].zz80.value) > parseFloat(document.forms[0].zz81.value))
      {
        document.forms[0].zz81.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz81.value != "" && document.forms[0].zz82.value !="")
    {
      if(parseFloat(document.forms[0].zz81.value) > parseFloat(document.forms[0].zz82.value))
      {
        document.forms[0].zz81.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz82.value != "" && document.forms[0].zz83.value !="")
    {
      if(parseFloat(document.forms[0].zz82.value) > parseFloat(document.forms[0].zz83.value))
      {
        document.forms[0].zz82.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz83.value != "" && document.forms[0].zz84.value !="")
    {
      if(parseFloat(document.forms[0].zz83.value) > parseFloat(document.forms[0].zz84.value))
      {
        document.forms[0].zz83.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz84.value != "" && document.forms[0].zz85.value !="")
    {
      if(parseFloat(document.forms[0].zz84.value) > parseFloat(document.forms[0].zz85.value))
      {
        document.forms[0].zz84.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz85.value != "" && document.forms[0].zz86.value !="")
    {
      if(parseFloat(document.forms[0].zz85.value) > parseFloat(document.forms[0].zz86.value))
      {
        document.forms[0].zz85.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz86.value != "" && document.forms[0].zz87.value !="")
    {
      if(parseFloat(document.forms[0].zz86.value) > parseFloat(document.forms[0].zz87.value))
      {
        document.forms[0].zz86.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz87.value != "" && document.forms[0].zz88.value !="")
    {
      if(parseFloat(document.forms[0].zz87.value) > parseFloat(document.forms[0].zz88.value))
      {
        document.forms[0].zz87.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz88.value != "" && document.forms[0].zz89.value !="")
    {
      if(parseFloat(document.forms[0].zz88.value) > parseFloat(document.forms[0].zz89.value))
      {
        document.forms[0].zz88.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz89.value != "" && document.forms[0].zz90.value !="")
    {
      if(parseFloat(document.forms[0].zz89.value) > parseFloat(document.forms[0].zz90.value))
      {
        document.forms[0].zz89.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz90.value != "" && document.forms[0].zz91.value !="")
    {
      if(parseFloat(document.forms[0].zz90.value) > parseFloat(document.forms[0].zz91.value))
      {
        document.forms[0].zz91.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz91.value != "" && document.forms[0].zz92.value !="")
    {
      if(parseFloat(document.forms[0].zz91.value) > parseFloat(document.forms[0].zz92.value))
      {
        document.forms[0].zz91.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz92.value != "" && document.forms[0].zz93.value !="")
    {
      if(parseFloat(document.forms[0].zz92.value) > parseFloat(document.forms[0].zz93.value))
      {
        document.forms[0].zz92.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz93.value != "" && document.forms[0].zz94.value !="")
    {
      if(parseFloat(document.forms[0].zz93.value) > parseFloat(document.forms[0].zz94.value))
      {
        document.forms[0].zz93.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz94.value != "" && document.forms[0].zz95.value !="")
    {
      if(parseFloat(document.forms[0].zz94.value) > parseFloat(document.forms[0].zz95.value))
      {
        document.forms[0].zz94.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz95.value != "" && document.forms[0].zz96.value !="")
    {
      if(parseFloat(document.forms[0].zz95.value) > parseFloat(document.forms[0].zz96.value))
      {
        document.forms[0].zz95.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz96.value != "" && document.forms[0].zz97.value !="")
    {
      if(parseFloat(document.forms[0].zz96.value) > parseFloat(document.forms[0].zz97.value))
      {
        document.forms[0].zz96.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz97.value != "" && document.forms[0].zz98.value !="")
    {
      if(parseFloat(document.forms[0].zz97.value) > parseFloat(document.forms[0].zz98.value))
      {
        document.forms[0].zz97.style.backgroundColor="#ff0000";
      }
    }

    if(document.forms[0].zz98.value != "" && document.forms[0].zz99.value !="")
    {
      if(parseFloat(document.forms[0].zz98.value) > parseFloat(document.forms[0].zz99.value))
      {
        document.forms[0].zz98.style.backgroundColor="#ff0000";
      }
    }
  }

  var theElement;
  var theElement_obs_ttl;
  var status = true;
  var i;

  for (i = 0; i < disabled_list_cnt; i++)
  {
    theElement = document.getElementById(disabled_list[i]);
    var color = theElement.style.backgroundColor;
    var value = theElement.value;
    if(value == "" && color == "cyan")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "pink")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "#ffc0cb")
    {
      status = false;
      theElement.style.backgroundColor="#ff0000";
    }
    else if(color == "#ffc0cc")
    {
      status = false;
      theElement.style.backgroundColor="#ff0001";
    }
    else if(color == "red" || color == "#ff0000" || color == "#ff0001")
    {
      status = false;
    }
  }

  for (i = 0; i < minimal_list_cnt; i++)
  {
    theElement = document.getElementById(minimal_list[i]);
    var color = theElement.style.backgroundColor;
    var value = theElement.value;
//  alert(value);
    if(color == "pink")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "#ffc0cb")
    {
      status = false;
      theElement.style.backgroundColor="#ff0000";
    }
    else if(color == "#ffc0cc")
    {
      status = false;
      theElement.style.backgroundColor="#ff0001";
    }
    else if(color == "red" || color == "#ff0000" || color == "#ff0001")
    {
      status = false;
    }
  }

  for (i = 0; i < cyan_list_cnt; i++)
  {
    theElement = document.getElementById(cyan_list[i]);
    var color = theElement.style.backgroundColor;
    var value = theElement.value;
    if(value == "" && color == "cyan")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "pink")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "#ffc0cb")
    {
      status = false;
      theElement.style.backgroundColor="#ff0000";
    }
    else if(color == "#ffc0cc")
    {
      status = false;
      theElement.style.backgroundColor="#ff0001";
    }
    else if(color == "red" || color == "#ff0000" || color == "#ff0001")
    {
      status = false;
    }
  }

  for (i = 0; i < yellow_list_cnt; i++)
  {
    theElement = document.getElementById(yellow_list[i]);
    var color = theElement.style.backgroundColor;
    var value = theElement.value;

    if(value == "" && color == "cyan")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "pink")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "#ffc0cb")
    {
      status = false;
      theElement.style.backgroundColor="#ff0000";
    }
    else if(color == "#ffc0cc")
    {
      status = false;
      theElement.style.backgroundColor="#ff0001";
    }
    else if(color == "red" || color == "#ff0000" || color == "#ff0001")
    {
      status = false;
    }
  }

  for (i = 0; i < silver_list_cnt; i++)
  {
    theElement = document.getElementById(silver_list[i]);
    var color = theElement.style.backgroundColor;
    var value = theElement.value;

    if(value == "" && color == "cyan")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "pink")
    {
      status = false;
      theElement.style.backgroundColor="red";
    }
    else if(color == "#ffc0cb")
    {
      status = false;
      theElement.style.backgroundColor="#ff0000";
    }
    else if(color == "#ffc0cc")
    {
      status = false;
      theElement.style.backgroundColor="#ff0001";
    }
    else if(color == "red" || color == "#ff0000" || color == "#ff0001")
    {
      status = false;
    }
  }

  if(status)
  {
    var clas_type = document.forms[0].clas_type.value;
    var dcls_sel = document.forms[0].dcls_sel.value;
    if((clas_type == "S" || clas_type == "C") && dcls_sel == 2)
    {
//    if(!valid_date(document.forms[0].dcls_yr.value,
//       document.forms[0].dcls_mon.value,
//       document.forms[0].dcls_day.value,
//       '00',
//       '00'))
//    {
//      document.forms[0].dcls_yr.style.backgroundColor="red";
//      document.forms[0].dcls_mon.style.backgroundColor="red";
//      document.forms[0].dcls_day.style.backgroundColor="red";
//      alert("Invalid destroy date");
//      return false;
//    }
//    else
//    {
        if(!age_date_future(document.forms[0].dcls_yr.value,
         document.forms[0].dcls_mon.value,
         document.forms[0].dcls_day.value,
         '00',
         '00'))
        {
          document.forms[0].dcls_yr.style.backgroundColor="red";
          document.forms[0].dcls_mon.style.backgroundColor="red";
          document.forms[0].dcls_day.style.backgroundColor="red";
          alert("Destroy date is in past");
          return false;
        }
//    }
    }


    if(data_type == "bathy_form" || data_type == "ship_sfc_form")
    {

    if(!valid_date(document.forms[0].obs_yr.value,
       document.forms[0].obs_mo.value,
       document.forms[0].obs_day.value,
       document.forms[0].obs_hr.value,
       document.forms[0].obs_min.value))
    {
      document.forms[0].obs_yr.style.backgroundColor="red";
      document.forms[0].obs_mo.style.backgroundColor="red";
      document.forms[0].obs_day.style.backgroundColor="red";
      document.forms[0].obs_hr.style.backgroundColor="red";
      document.forms[0].obs_min.style.backgroundColor="red";
      alert("Invalid obs date");
      return false;
    }
    else
    {
      if(!age_date_past(document.forms[0].obs_yr.value,
        document.forms[0].obs_mo.value,
        document.forms[0].obs_day.value,
        document.forms[0].obs_hr.value,
        document.forms[0].obs_min.value))
      {
        document.forms[0].obs_yr.style.backgroundColor="red";
        document.forms[0].obs_mo.style.backgroundColor="red";
        document.forms[0].obs_day.style.backgroundColor="red";
        document.forms[0].obs_hr.style.backgroundColor="red";
        document.forms[0].obs_min.style.backgroundColor="red";
        alert('Obs date is in future');
        return false;
      }
    }

    }
  }

  if(status)
  {
//
// Determine transmit time
//
    var today_2 = new Date();
    var send_year=today_2.getUTCFullYear();
    var send_month=today_2.getUTCMonth()+1;
    var send_day=today_2.getUTCDate();
    var send_hour=today_2.getUTCHours();
    var send_minute=today_2.getUTCMinutes();
    var send_second=today_2.getUTCSeconds();
    document.forms[0].client_send_time.value=send_year+"_"+send_month+"_"+send_day+"_"+send_hour+"_"+send_minute+"_"+send_second;
//  Win=window.open("ship_sfc.cgi","Win",'toolbar=no,menubar=no,scrollbars=yes,resizable=yes');
//  Win.window.resizeTo('1000','600');
//  Win.window.focus();

// Check for US Navy ship and classification
    if(document.forms[0].clas_type.value == "U")
    {
      if(document.forms[0].ship_title.value == "USS" || document.forms[0].ship_title.value == "USNS") 
      {
//      if(! confirm("You are submitting an UNCLASSIFIED J-OBS report from from a US Navy vessel.\n Do you wish to proceed?"))
        if(! confirm("You are submitting an UNCLASSIFIED J-OBS report from a US Navy vessel.\nAre you in compliance with OPNAVINST 5513.3B regarding the current location of this vessel?\nClick OK if you wish to proceed?"))
        {
          return false;
        }
      }
    }


    return true;
  }
  else
  {
    alert('Values in red are either undefined or incorrect');
    return false;
  }

}

function reset_parm(value)
{
  var theElement;
  var i;
  var ii;
  var iii;
  var test;
  var color;
  if(value == 1) // METAR
  {
    for (i=0; i<parm_list_1_cnt; i++)
    {
      color = "cyan";
      theElement = document.getElementById(parm_list_1[i]);
      for (iii=0; iii<parm_list_pos_cnt; iii++)
      {
        if (parm_list_1[i] == parm_list_pos[iii])
        {
          color="yellow";
        }
      }
      theElement.style.backgroundColor=color;
      theElement.disabled=false;
    }
  }
  else if(value == 2) // SPECI
  {
    for (i=0; i<parm_list_2_cnt; i++)
    {
      color = "cyan";
      theElement = document.getElementById(parm_list_2[i]);
      for (iii=0; iii<parm_list_pos_cnt; iii++)
      {
        if (parm_list_2[i] == parm_list_pos[iii])
        {
          color="yellow";
        }
      }
      theElement.style.backgroundColor=color;
      theElement.disabled=false;
    }

    for (i=0; i<parm_list_1_cnt; i++)
    {
      test = 0;
      for (ii=0; ii<parm_list_2_cnt; ii++)
      {
        if (parm_list_1[i] == parm_list_2[ii])
        {
          test = 1;
        }
      }
      if (test == 0)
      {
        theElement = document.getElementById(parm_list_1[i]);
        theElement.style.backgroundColor="silver";
        theElement.disabled=false;
      }
    }
  }
  else if(value >= 3 && value <= 5)  // SPECI special circumstances
  {
    for (i=0; i<parm_list_3_5_cnt; i++)
    {
      color = "cyan";
      theElement = document.getElementById(parm_list_3_5[i]);
      for (iii=0; iii<parm_list_pos_cnt; iii++)
      {
        if (parm_list_3_5[i] == parm_list_pos[iii])
        {
          color="yellow";
        }
      }
      theElement.style.backgroundColor=color;
      theElement.disabled=false;
    }

    for (i=0; i<parm_list_1_cnt; i++)
    {
      test = 0;
      for (ii=0; ii<parm_list_3_5_cnt; ii++)
      {
        if (parm_list_1[i] == parm_list_3_5[ii])
        {
          test = 1;
        }
      }
      if (test == 0)
      {
        theElement = document.getElementById(parm_list_1[i]);
        theElement.style.backgroundColor="silver";
        theElement.disabled=false;
      }
    }
  }
  else // SEPCI local requirements
  {
    for (i=0; i<parm_list_6_cnt; i++)
    {
      color = "cyan";
      theElement = document.getElementById(parm_list_6[i]);
      for (iii=0; iii<parm_list_pos_cnt; iii++)
      {
        if (parm_list_6[i] == parm_list_pos[iii])
        {
          color="yellow";
        }
      }
      theElement.style.backgroundColor=color;
      theElement.disabled=false;
    }

    for (i=0; i<parm_list_1_cnt; i++)
    {
      test = 0;
      for (ii=0; ii<parm_list_6_cnt; ii++)
      {
        if (parm_list_1[i] == parm_list_6[ii])
        {
          test = 1;
        }
      }
      if (test == 0)
      {
        theElement = document.getElementById(parm_list_1[i]);
        theElement.style.backgroundColor="silver";
        theElement.disabled=false;
      }
    }
  }
}

function check_int_range_required_obs_hr(str,min,max,id)
{
  var theElement;
  if (!check_int_state(str,id)) return false;
  if (str < min || str > max)
  {
    theElement = document.getElementById(id);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Out of range');
    return false;
  }
  theElement = document.getElementById(id);
  theElement.style.backgroundColor="cyan";
  var hr = parseInt(str);
  var mn = parseInt(document.forms[0].obs_min.value);
  if (mn >= 55)
  {
    hr = hr + 1;
    mn = 0;
  }
  if ((hr == 0 || hr == 3 || hr == 6 || hr == 9 || hr == 12 || hr == 15 || hr == 18 || hr == 21 || hr == 24) && mn == 0)
  {
    var i;
    for (i = 0; i < part2_cnt; i++)
    {
      if(part2_list[i]  != "pres_tdcy_amt" && part2_list[i]  != "pres_tdcy_char_id")
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="cyan";
      }
      else if ((part2_list[i]  == "pres_tdcy_amt" || part2_list[i] == "pres_tdcy_char_id") && document.forms[0].observer_title.value == "aerographer's mate")
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="cyan";
      }
      else
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="silver";
      }
    }
    alert('Part 2 is also now required');
  }
  else if (document.forms[0].obs_min.value != "")
  {
    var i;
    for (i = 0; i < part2_cnt; i++)
    {
      theElement = document.getElementById(part2_list[i]);
      theElement.style.backgroundColor="silver";
    }
    if(check_part2())
    {
      if(confirm('Reset Part 2?'))
      {
        reset_part2();
      }
    }
  }
  return true;
}

function check_int_range_required_obs_min(str,min,max,id)
{
  var theElement;
  if (!check_int_state(str,id)) return false;
  if (parseInt(str) < parseInt(min) || parseInt(str) > parseInt(max))
  {
    theElement = document.getElementById(id);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    alert('Out of range');
    return false;
  }
  theElement = document.getElementById(id);
  theElement.style.backgroundColor="cyan";
  var hr = parseInt(document.forms[0].obs_hr.value);
  var mn = parseInt(str);
  if (mn >= 55)
  {
    hr = hr + 1;
    mn = 0;
  }
  if ((hr == 0 || hr == 6 || hr == 12 || hr == 18 || hr == 24) && mn == 0)
  {
    var i;
    for (i = 0; i < part2_cnt; i++)
    {
      if(part2_list[i]  != "pres_tdcy_amt" && part2_list[i]  != "pres_tdcy_char_id")
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="cyan";
      }
      else if ((part2_list[i]  == "pres_tdcy_amt" || part2_list[i] == "pres_tdcy_char_id") && document.forms[0].observer_title.value == "aerographer's mate")
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="cyan";
      }
      else
      {
        theElement = document.getElementById(part2_list[i]);
        theElement.style.backgroundColor="silver";
      }
    }
    alert('Part 2 is also now required');
  }
  else if (document.forms[0].obs_hr.value != "")
  {
    var i;
    for (i = 0; i < part2_cnt; i++)
    {
      theElement = document.getElementById(part2_list[i]);
      theElement.style.backgroundColor="silver";
    }
    if(check_part2())
    {
      if(confirm('Reset Part 2?'))
      {
        reset_part2();
      }
    }
  }
  return true;
}

function reset_part2()
{
  var theElement;
  var i;
  for (i = 0; i < part2_name_cnt; i++)
  {
    theElement = document.getElementById(part2_name_list[i]);
    theElement.value=part2_value_list[i];
  }
}

function check_part2()
{
  var theElement;
  var i;
  for (i = 0; i < part2_name_cnt; i++)
  {
    theElement = document.getElementById(part2_name_list[i]);
    if(theElement.value != part2_value_list[i])
    {
      return true;
    }
  }
  return false;
}

function check_file_ext(id,str)
{
  var theElement;
  var theElement = document.getElementById(id);
  var file = theElement.value;
  var ext = file.substring(file.length-3,file.length);
  ext = ext.toLowerCase();
  if(ext != str .and. ext != "bfr")
  {
    alert('Please ensure that the file you selected is a Plain Text file before submitting.');
    alert(file.substring);
    alert(ext);
    alert(str);
    theElement.style.backgroundColor="pink";
//  theElement.focus();
//  theElement.select();
    return false;
  }
  else
  {
    theElement.style.backgroundColor="cyan";
    return true;
  }
}

function clearFileInput()
{
    var oldInput = document.getElementById("upload_wmo_file");
    
    var newInput = document.createElement("input");
    
    newInput.type = "file";
    newInput.id = oldInput.id;
    newInput.name = oldInput.name;
    newInput.className = oldInput.className;
    newInput.style.cssText = oldInput.style.cssText;
    // copy any other relevant attributes
    
    oldInput.parentNode.replaceChild(newInput, oldInput);
}
