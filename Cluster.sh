
# Avance Edwin Enriquez algunos datos configuracion basica cluster
#!/bin/bash 
#Global Variable
touch  /tmp/Chapter.xml
Chap=/tmp/Chapter.xml 

echo "<?xml version='1.0' encoding='utf-8' ?>"> $Chap
echo '<!DOCTYPE chapter PUBLIC "-//OASIS//DTD DocBook XML V4.5//EN" "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" [' >> $Chap 
echo '<!ENTITY % BOOK_ENTITIES SYSTEM "redhat-Consulting.ent">' >> $Chap
echo '%BOOK_ENTITIES;' >> $Chap
echo ']>' >> $Chap 


#Build the chapter id 
echo '<chapter id="chap-redhat-Consulting-Datos_Generales">' >> $Chap 
# Title are created as needed 
echo -e '\t<title>Datos Generales del Sistema</title>' >> $Chap
	# tag <para> to paragraph </para> to Datos Generales del Sistema 
	echo -e '\t<para>' >> $Chap 
	echo -e '\t\tLa información es obtenida mediante comandos del sistema el día-mes-año, dicha información puede ser modificada con el paso del tiempo.' >> $Chap
	echo -e '\t</para>' >> $Chap
	# end tag to Datos Generales del Sistema
	
	
	# Define Hardware section and titles
echo -e '\t<section id="sect-redhat-Consulting-Datos_Generales-Información_Networking_1">' >> $Chap
echo -e '\t\t<title></title>' >> $Chap
	# tag <para> to paragraph </para> to Hardware title
	echo -e '\t\t<para>' >> $Chap
	echo -e '\t\t\t' >> $Chap 
	#Create list items <segmentedlist> 
	#Variables Hardware
	# finding Characteristics


	#informacion 
	NOMBRECLUSTER=$(cat /etc/cluster/cluster.conf |grep 'cluster name'| awk 'BEGIN { FS = "\"" } ; { print $2 }')
	NUMCLUSTER=$(cat /etc/cluster/cluster.conf | grep -c nodeid)
	CLUSTERS=$(cat /etc/cluster/cluster.conf |grep 'clusternode name'| awk 'BEGIN { FS = "\"" } ; { print "\n<listitem><para>Nombre "$2 "  ID" $4"</para></listitem>" "\n" }')
	
	




	# end finding
		echo -e '\t\t\t<segmentedlist> <title>Informacion </title>' >> $Chap
		
		echo -e '\t\t\t<?dbhtml list-presentation="list"?>' >> $Chap
			echo -e '\t\t\t\t<segtitle>Nombre del Cluster</segtitle>' >>$Chap
			echo -e '\t\t\t\t<segtitle>Numero de Clusters</segtitle>' >>$Chap
			echo -e '\t\t\t\t<segtitle>Clusters</segtitle>' >>$Chap

		

			echo -e '\t\t\t\t<seglistitem>' >> $Chap
	
				echo -e "\t\t\t\t<seg>$NOMBRECLUSTER</seg>" >> $Chap
				echo -e "\t\t\t\t<seg>$NUMCLUSTER</seg>" >> $Chap


				echo -e '\t\t\t\t<title>Clusters</title>' >>$Chap
				echo -e "\t\t\t\t<itemizedlist>$CLUSTERS</itemizedlist>" >> $Chap




			echo -e '\t\t\t\t</seglistitem>' >> $Chap
		echo -e '\t\t\t</segmentedlist>' >> $Chap
	# end list items ,/segmentedlist> 
		echo -e '\t\t</para>' >> $Chap
		
		
	

	# end tag <para> to paragraph </para> to Hardware title
		echo -e '\t</section>\n' >> $Chap
	# end tag section to Hardware and create new section to Informaci[on del sistema
	
	
	
	
	
	
	echo '</chapter>' >> $Chap

