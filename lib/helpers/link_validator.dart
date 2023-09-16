String? validateLink(String? url){
if(url==null||url.isEmpty) return 'Please Enter A Link';
return  Uri.parse(url).isAbsolute? null:'Please Enter A Valid Link';
}