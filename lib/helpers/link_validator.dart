String? validateLink(String? url){
if(url==null||url.isEmpty) return 'Please Enter A Link';

try{
 bool isAbsolute= Uri.parse(url.toString()).isAbsolute;
  return  isAbsolute? null:'Please Enter A Valid Link!';

}
catch(e){
  return 'Please Enter A Valid Link!';
}
}