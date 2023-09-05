*******************************************************************************
*                 ****
*******************************************************************************
//Parte 1 
//punto1
global dir "C:\Users\sebas\OneDrive\Desktop\STATA\TALLER2"
//punto 1.1
cd "${dir}\Data"
unzipfile "DATA.zip"
//Extraer documentos zip
//punto 2

 foreach year in "2015" "2016" {
	
	foreach area in "Cabecera" "Resto" {
	*display "`year' -  `areas''" - 
	cd "${dir}\\Data\Data\\`year'\\`area'"
	
	unzipfile  "zipped.zip", replace 
	
	}
}
//punto 3
use "${dir}\Data\Data\2015\Cabecera\Cabecera2015m2", replace 
//browse

/*a. La primera observación corresponde a un hombre jefe del hogar cuya fecha  de nacimiento es en octubre de 1972 tiene 42 años . Es jefe de hogar, esta separado y  se encuentra afiliado a un regimen especial de salud del cual es subsidiado. El hombre afirma que en los ultimos doce meses no ha dejado de asistir al medico y sabe leer y escribir.Ademas, actualmente no asiste al colegio o universidad  y el nivel educativo más alto que alcanzo fue basica primaria hasta segundo grado.La mayor parte de tiempo que dedico la semana pasada fue en servicios del hogar y recibio una remuneración por una hora o más. Se observa que trabaja en servicios varios dentro de los que se encuentra plomero, taxista, servicio domestico por dias de la cual recibio 75.000 lo cual corresponde a un mes de trabajo.En los ultimos 12 meses  trabajo 10 meses.Respecto a su hogar  se evidencia que  es un usufructo, no cuenta con servicio telefonico, ni calentador, ni microondas pero si de un televisor a color.Es separado y su hogar esta conformado por 3 personas*/

/*b. Las unidades de observación son directorio, secuencia_p, orden y month  los cuales 
 permiten conocer el identificador unico de cada observacion en la base de datos*/ 

/*c. /*c. Las variables que permiten establecer la unidad de identificacion de la base de datos son directorio orden secuencia_p y month . Esto lo podemos confirmar con el comando unique, el cual nos da una tabulación del numero unico de variables el cual es igual al numero de observaciones */

  /*d. esta base de datos tiene una estructura larga ya que tiene una cierta cantidad de columnas que cumplen el rol de identificadores y cuya combinación identifican una única observación y una única columna con el valor de la observación.*/
 
 /*e.En general, el formato ancho es más compacto y legible por humanos mientras que el largo es más fácil de manejar con la computadora.Por lo que el ideal para el analisisis de datos es el ancho.*/
 
 *f.*/
  //type "${dir}\Data\Data\2015\Cabecera\Cabecera2015m2"
 
 //use "${dir}\Data\Data\2015\Cabecera\Cabecera2015m1"
 
 *a. La primera observación corresponde a un hombre que nacio en enero de 1973, tiene actualmente 41 años.Es el jefe del hogar esta casado . Es jefe de hogar que cotiza a seguridad social y se encuentra afiliado a un regimen especial de salud del cual le descuentan mensualmente 41.000. El hombre afirma que en los ultimos 12 meses no ha dejado de asistir al medico, saber leer y ecribir y el maximo nivel de estudios fue basica primaria en la que estubo hasta primero.Actualmente cuenta con un trabajo a termino indefinido en el cual el mes pasado tuvo una ganancia de 1.500.000 Tambien se evidencia que el hogar de esta persona esta conformado por su esposa y dos hijos menores de edad.*/

/*b. Las unidades de observación son directorio, secuencia_p, orden y month los cuales permiten conocerel identificador unico de cada observacion en la base de datos*/ 

/*c. Las variables que permiten establecer la unidad de identificacion de la base de datos son directorio orden secuencia_p y month . Esto lo podemos confirmar con el comando unique, el cual nos da una tabulación del numero unico de variables el cual es igual al numero de observaciones */

/*d.esta base de datos tiene una estructura larga ya que tiene una cierta cantidad de columnas que cumplen el rol de identificadores y cuya combinación identifican una única observación y una única columna con el valor de la observación.*/

 /*e.En general, el formato ancho es más compacto y legible por humanos mientras que el largo es más fácil de manejar con la computadora.Por lo que el ideal para el analisis de datos es el ancho .*/

  * Las bases que pudimos observar tienen la misma unidad de identificación.*/

//Punto 4

foreach year in "2015" "2016"{
 	
		foreach area in "Cabecera" "Resto"{
			clear all
		foreach mes in 1 2 3 {
			append using "${dir}\Data\Data\\`year'\\`area'\\`area'`year'm`mes'", force
		}
		
		save "${dir}\Work\\`area'`year'", replace
		
 }

 }

forvalue year = 2015/2016{
 	
		use "${dir}\Work\Resto`year'", clear
		append using "${dir}\Work\Cabecera`year'",
		merge 1:1 directorio secuencia_p orden month using "${dir}\\Data\Data\\`year'\\fe`year'"
		keep if _merge == 3
		save "${dir}\Work\geih`year'", replace
	
 } 
 
//punto 6 
clear all
use "${dir}\Work\geih2015"
append using "${dir}\Work\geih2016", force

save "${dir}\Work\geih", replace
* tab year

//punto 7
gen nivel_esc=1 if esc==0
replace nivel_esc=2 if inrange(esc,1,6)==1
replace nivel_esc=3 if inrange(esc,6,12)==1
replace nivel_esc=4 if inrange(esc,12,17)==1
replace nivel_esc=5 if inrange(esc,17,27)==1

//punto 8 
 label define nivel_esc 1 "Sin escolaridad" 2 "Primaria" 3 "Secundaria" 4 "Universitaria" 5 "Posgrado" 
 
 
//punto 9
*9.1
rename p6020 genero
rename oci ocupados
rename dsi desocupados
*9.2
collapse (mean) inglabo (sum) desocupados ocupados [aweight=fe], by(genero year nivel_esc)

***9.3
drop if nivel_esc ==.

***9.4
gen PoblaciónEconomicamenteActiva = desocupados + ocupados 

***9.5
gen TasaDesempleo = desocupados/PoblaciónEconomicamenteActiva

*Punto 10
reshape wide ocupados inglabo desocupados PoblaciónEconomicamenteActiva TasaDesempleo , i(year nivel_esc) j(genero)

*punto 11
gen brecha = inglabo1 - inglabo2
bys nivel_esc: gen cambio = brecha[_n-1] 
gen cambio_brecha = brecha-cambio

*Punto 12
save "${dir}\Work\final_basedatos", replace
export excel _all using "${dir}\Work\base_datos.xlxs", replace

*12.1
**¿Encuentra evidencia de que la brecha salarial entre hombres y mujeres se redujo entre 2015 y 2016? [1 punto]
//De acuerdo a la base de datos obtenida no se encuentra evidencia de que  entre 2015 y 2016 se redujo la brecha salatrial entre mujeres y hombres.Ya que la variable cambio_brecha muestra valores positivos, lo cual indica que la brecha salarial entre mujeres y hombres aumento. Sin embargo, observamos que se redujo entre los que tienen un postgrado.

**¿Cu´ales son los niveles de escolaridad con la mayor y menor tasa de desempleo en las mujeres? [1 punto]

//De acuerdo a la informacion de la base de datos. Las mujeres con nivel de escolaridad universitario son quienes mas tasa de desempleo reportan. Lo anterior se puede observar ya que en el 2015 y 2016 la  tasa de desempleo fue de 16.43% y 18.91% respectivamente.La menor tasa de desempleo se presenta en las mujeres que no tienen ningun nivel de escolaridad con 06,99% y 07,19%

**En alg´un nivel de escolaridad, ¿la tasa de desempleo es m´as baja en las mujeres que en los hombres? ¿qu´e pas´o en el a˜no siguiente?
 
//En ningun nivel de escolaridad las mujeres tienen una menor tasa de desempleo respecto a los hombres, se evidencia es una gran brecha salarial en todos los niveles de estudio entre hombres y mujeres.Se observa que en todos los niveles educativos menos de posgrado  en 2016 aumenta la brecha y la tasa de desempleo en las mujeres sube en el año 2016 en los niveles de escolaridad 1 y 3.




