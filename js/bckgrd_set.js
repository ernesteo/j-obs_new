var i;
for (i=0; i<minimal_list_cnt; i++)
{
  var theElement = document.getElementById(minimal_list[i]);
  theElement.style.backgroundColor="cyan";
}
for (i=0; i<cyan_list_cnt; i++)
{
  var theElement = document.getElementById(cyan_list[i]);
  theElement.style.backgroundColor="cyan";
}
for (i=0; i<silver_list_cnt; i++)
{
  var theElement = document.getElementById(silver_list[i]);
  theElement.style.backgroundColor="silver";
}
for (i=0; i<yellow_list_cnt; i++)
{
  var theElement = document.getElementById(yellow_list[i]);
  theElement.style.backgroundColor="yellow";
}
for (i=0; i<disabled_list_cnt; i++)
{
  var theElement = document.getElementById(disabled_list[i]);
  theElement.style.backgroundColor="#808080";
  theElement.disabled=true;
}
