#!/bin/bash
#
# Codigo que muestra si el servicio GFS esta funcionando

touch	/tmp/Chapter.xml
Chap=/tmp/Chapter.xml 

echo "<?xml version='1.0' encoding='utf-8' ?>" > $Chap
echo '<!DOCTYPE chapter PUBLIC "-//OASIS//DTD DocBook XML V4.5//EN" "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" '>>$Chap
echo '[<!ENTITY % BOOK_ENTITIES SYSTEM "prueba.ent"> %BOOK_ENTITIES;]>' >> $Chap

#####obteniendo informacion del cluster y guardando en variables
#sacar informacion de clusterEdwin Enriquez
C=$(cat /etc/cluster/cluster.conf |grep -c nodeid)

#Build the chapter id 
echo '<chapter id="chap-prueba-Test_Chapter">' >> $Chap
	echo -e '\t<title>Servicio Cluster</title>' >> $Chap
	echo -e '\t<para>' >> $Chap
	echo -e '\t\tServicios, configuraciones y pruebas de clusters' >> $Chap
		echo -e '\t</para>' >> $Chap

		echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_1">' >> $Chap
		echo -e '\t\t<title>Cluster</title>' >>$Chap	
		#if [ -f /etc/cluster/cluster.conf ]; then
		#	echo -e '\t\t<subtitle>Archivo cluster.conf</subtitle>' >>$Chap
		#	echo -e '\t\t<screen>'>>$Chap
		#	cat /etc/cluster/cluster.conf >>$Chap
		#	echo -e '\t\t</screen>'>>$Chap
			
		#fi
			
		echo -e '\t\t<subtitle>Nodos Cluster</subtitle>' >>$Chap
		
##Edwin Enriquez
i=1
while (( i <= C  ))
do

echo -e '\t<para> ' >> $Chap
echo -e 'nombre del nodo con id=' $i >> $Chap 
echo -e '\t</para>' >> $Chap
echo -e '\t<para> ' >> $Chap
echo -e $(cat /etc/cluster/cluster.conf |grep -A 99999  nodeid=\"$i\" | grep -m1 -B 99999 '</clusternode>'|grep 'clusternode name'|awk 'BEGIN{FS="\""};{print $2" "}' ) >> $Chap
echo -e '\t</para> ' >> $Chap
echo -e '\t<para> ' >> $Chap
echo -e  "informacion por fence" >> $Chap
echo -e '\t</para> ' >> $Chap
FENCEACTUAL=$(cat /etc/cluster/cluster.conf |grep -A 99999  nodeid=\"$i\" | grep -m1 -B 99999 '</clusternode>'|grep -A 999 '<fence'|grep -B 999 '</fence')
echo -e $(echo $FENCEACTUAL|  sed 's/<method name=/\t<para> nombre del metodo/g'| sed 's/<fence>//g'| sed 's/<\/fence>//g'| sed 's/<device name=/nombre del dispositivo/g' | sed 's/<\/method>/\t<\/para>/g' | sed 's/\/>//g' | sed 's/\">/"/g' ) >>$Chap
#sed 's// /g'|
let i=i+1
done  ##fin Edwin Enriquez 
	echo "</section>">>$Chap
	echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_2">' >> $Chap
		echo -e '\t\t<title>Servicio GFS2</title>' >>$Chap	
	###Daniel Tinajero
		FlagGFSDaemon=$(ps -e | grep -c gfs2) #bandera que se activa si el demonio gfs2 esta activo
		NumMountGFS=$(mount -l -t gfs2 | grep -c gfs2) #Numero de GFS2 montados en el nodo actual
		if [ "$FlagGFSDaemon" -ge "1" -a $NumMountGFS -ge 1 ];
			then 
			Lista=$(mount -l | grep gfs2 | awk 'BEGING { } ; {print "\n\t\t\t\t<listitem>\n\t\t\t\t\t<para>Tipo " $5 " del dispositivo " $1"</para>\n\t\t\t\t</listitem>"}') 
			Parrafo="El servicio de GFS2 esta activo y montado en \n\t\t\t<orderedlist>$Lista\n\t\t\t</orderedlist>"
		else
			Parrafo="El servicio de GFS2 no esta activo debido a que no se encontro ningun dispositivo del tipo gfs2 ni el demonio de gfs2"
		fi
		echo -e "\t\t<para>">>$Chap
		echo -e "\t\t\t$Parrafo" >>$Chap
		echo -e "\t\t</para>" >>$Chap	
	echo -e '\t</section>' >> $Chap

############################################# HA	
echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_3">' >> $Chap
echo -e '\t\t<title>Scripts HA</title>' >>$Chap	
	pathClustat=$(whereis clustat | awk '{print $2}')

if [ "$pathClustat" == "" ]; then
	echo -e "\t<para>" >>$Chap
	echo "El programa clustat no esta instalado">>$Chap
	echo -e "\t</para>">>$Chap
else
	outputClustat=$(clustat)
	echo -e "<screen>">>$Chap
	echo -e "$outputClustat">>$Chap
	echo -e "</screen>">>$Chap
fi


echo -e '\t</section>' >>$Chap
###################################Servicios
	
echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_4">' >> $Chap
		echo -e '\t\t<title>Servicios configurados</title>' >>$Chap	

if [ -f /etc/cluster/cluster.conf ]; then

	cServicios=$((perl -lne 'BEGIN{undef $/} 
	while (/<service(.*?)<\/service>/sg){
		print "#", $1,"#"  	
	}' /etc/cluster/cluster.conf ) |grep -c [a-z] )
	if [ $cServicios -ne 0 ];then 
	
	(perl -lne 'BEGIN{undef $/} 
	while (/<service(.*?)<\/service>/sg){
		print "#", $1,"#"  	
	}' /etc/cluster/cluster.conf ) | awk '{ if( $0 ~ /#(.*?)>$/ && $0 !~ /\/>$/ )
					
						for(i=1;i<=NF;i++){
							if($i ~ /name="/){
								gsub(/name=/,"");
								
								gsub(/>/,"");
								print "\t\t\t<para>Servicio",$i," </para>"
								print "\t\t\t<para>Recursos</para>"
							}
						}
					}
					{	
						
						if( $0 ~ /<fs(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tFS:</para>"
							
							gsub(/<fs/,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							
							print $0
							
						}
						else if( $0 ~ /<ip(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tIP:</para>"
							
							gsub(/<ip/,"_para");
							gsub(/address/,"direccion");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							print $0	
							
						}
						else if( $0 ~ /<script(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tScripts:</para> "
							gsub(/<script/,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							print $0
							
						}
						else if( $0 ~ /<[a-z|A-Z](.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tOtros:</para> "
							
							gsub(/<!-(.*?)/,"");
							gsub(/</,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/\/>/,"_finpara");
							gsub(/>/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							
							print $0
							
						}
						
						
					}
					
					 ' >>$Chap
	else
	echo "<para>No existen servicios asociados al cluster</para>">>$Chap
	fi

else
	echo "<para>no existe el archivo cluster.conf</para> ">>$Chap
fi
echo -e '\t</section>' >> $Chap
#################################### Recursos
echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_5">' >> $Chap
		echo -e '\t\t<title>Recursos configurados</title>' >>$Chap	

if [ -f /etc/cluster/cluster.conf ]; then

	cRecursos=$((perl -lne 'BEGIN{undef $/}
	while (/<resources>(.*?)<\/resources>/sg){
	print "#", $1,"#"
	}' /etc/cluster/cluster.conf ) | grep -c [a-z] )
	if [ $cRecursos -ne 0 ];then 

	(perl -lne 'BEGIN{undef $/} 
	while (/<resources>(.*?)<\/resources>/sg){
		print "#", $1,"#"  	
	}' /etc/cluster/cluster.conf ) | awk '{ 
					
						if( $0 ~ /<fs(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tFS:</para>"
							
							gsub(/<fs/,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							
							print $0
							
						}
						else if( $0 ~ /<ip(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tIP:</para>"
							
							gsub(/<ip/,"_para");
							gsub(/address/,"direccion");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							print $0	
							
						}
						else if( $0 ~ /<script(.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tScripts:</para> "
							gsub(/<script/,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/[\/>|>]$/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							print $0
							
						}
						else if( $0 ~ /<[a-z|A-Z](.*?)[>$|\/>$]/){
							print "\t\t\t<para>\tOtros:</para> "
							
							gsub(/<!-(.*?)/,"");
							gsub(/</,"_para");
							gsub(/name/,"nombre");
							gsub(/ref=/,"Recurso global=");
							gsub(/\/>/,"_finpara");
							gsub(/>/,"_finpara");
							gsub(/_para/,"\t\t<para>\t\t");
							gsub(/_finpara/,"</para>");
							
							print $0
							
						}
						
			 } '>>$Chap
	else
	echo "<para>No existen recursos asociados al cluster</para>">>$Chap
	fi
	
else
	echo  "<para>no existe el archivo cluster.conf</para> ">>$Chap
fi


echo -e '\t</section>' >> $Chap






########################################################### configuracion de almacenamiento

echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_6">' >> $Chap
		echo -e '\t\t<title>Configuracion de almacenamiento </title>' >>$Chap	


		echo -e '\t\t<subtitle>Volumenes </subtitle>' >>$Chap	





 vgdisplay -v| awk '{  if (($1=="LV"&& $2=="Name")||($1=="LV"&& $2=="Size")||($1=="LV"&& $2=="Path")){print "<para>"$1" " $2": " $3" "$4"</para>"}}' >> $Chap

echo -e '\t<para> ' >> $Chap
awk BEGIN'{ printf "8.- Almacenamiento (HDD): \n"}' | df -h | awk '{print $1"  " $2}' | grep "/dev/">> $Chap
echo -e '\t</para> ' >> $Chap

echo -e '\t</section>' >> $Chap
################################################### configuracion de red
echo -e '\t<section id="sect-prueba-Test_Chapter-Test_Section_7">' >> $Chap
		echo -e '\t\t<title>Configuracion de Red </title>' >>$Chap	

varie=$(netstat -i| awk '{print $1}')
##echo $varie


for f in $varie
do
if ((ip  a|grep -c $f)>0) then

echo -e '<para> ' >> $Chap

echo "Tarjeta:"$f >> $Chap

echo -e '</para> ' >> $Chap

echo -e '<para> ' >> $Chap
echo "IP:" >> $Chap
echo -e '</para> ' >> $Chap
echo -e '<para> ' >> $Chap
ip  a|grep -A6 $f':'| grep -iE '([0-9]{1,3}\.){3}[0-9]{1,3}' >> $Chap
echo -e '</para> ' >> $Chap
echo -e '<para> ' >> $Chap
echo "MAC:" >> $Chap
echo -e '</para> ' >> $Chap
echo -e '<para> ' >> $Chap
ip a|grep -A6 $f':'| grep -iE '([0-9A-F]{2}:){5}[0-9A-F]{2}' >> $Chap
echo -e '</para> ' >> $Chap



fi
done


echo -e '\t</section>' >> $Chap


############################################################################################################


echo '</chapter>' >> $Chap
		

