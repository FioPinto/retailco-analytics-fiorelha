# Resumen final

## Objetivo del proyecto

Este proyecto consistió en tomar un porcentaje de datos de ejemplo que vienen dados por Snowflake. Estos datos se han modelado usando dbt, creando capas por las que pasan los datos de un estado crudo sin ninguna modificación, raw, a un estado limpio, staging.

A partit de los modelos de staging se han creado modelos de intermediate, en esta capa se ha llevado a cabo la unificación de modelos como las ventas, las cuales estban previamente divididas en tablas según su medio (tienda, catálog o web).

De esa capa se ha pasado a la de marts, en la cual se han creado 3 modelos, que responden a preguntas de negocio importantes, los cuales se prepararon para poder consumirlos en herramientas de análisis de datos como Power BI.

Todo este proceso a llevado a cabo tmabién la creación de macros, tests y docs. Al final se ha obtenido una dashboard de Power BI funcional.

## Decisiones principales

Al crear el mart `mart_customer_lifetime_value` me encontré con 4 resultados en los cuales, al calcular la columna `clv = lifetime_revenue - total_returns` me salía un clv negativo, lo cual no tenía sentido, entendiendo que el `lifetime_revenue` son ingresos totales generados por el cliente a lo largo del tiempo y `total_returns`es el importe total de devoluciones realizadas por el cliente.

Si `clv`sale negativo significa que el cliente ha devuelto más de lo que ha gastado, esto se podría deber a que los ingresos que devuelva incluya impuestos o descuentos distintos a revenue. Debido a que no sabía la razón decidí aislar esos casos y transformar a 0 el `clv`si es negativo.

Esta decisión también afecta a la columna `return_rate` que divide a `total_returns` entre `lifetime_revenue`, por lo cual también aisle esos casos. Cuando hay un `return_rate` mayor de 1 lo transforma a 1.

La última repercusión que tuvo es el hecho de que al usar el test `dbt_expectations.expect_column_pair_values_A_to_be_greater_than_B` del paquete `dbt_expectations` al comparar las dos columnas todavía están los datos ilógicos, por lo cual decidí que tengan una severidad de `warn` ya que no quise quitarlos simplemente y con warn se podrán revisar con más contexto en una situación real.

## Aprendizaje

Con esta práctica he fortalezido mis conocimientos que obtuve haciendo los cursos de dbt, descubrí comandos deprecados como `dbt docs generate` y `dbt docs serve`, por lo que seguí las instrucciones de usar el comando `dbt compile --write-catalog`, buscar el archivo `index.html` en el repositorio de github indicado y levantar un servidor con python para poder ver la documentación.