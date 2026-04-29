# Proyecto Inicial

## Descripción

Este proyecto es una práctica para afianzar conocimientos sobre Snowflake y Dbt. Consiste en una base de datos creada a partir de un sample datos de Snowflake, los caules se modelaran en fases hasta conseguir datos enriquecidos para usar en análisis.

## Instrucciones

Al usar la herramienta `dbt_core` junto con la extensión de dbt para Visual Studio Code se crean las carpetas necesarias para un proyecto dbt a partir del comando `dbtf init`.

Una vez ejecutado ese comando pedirá que se configure la conexión a la base de datos de Snowflake, se introducirá los credenciales ademñas de especificar que base de datos, esquema y warehouse debe usar.

## Lista de modelos

1. Capa de Staging (staging/tpcds)

Modelos que limpian y dan formato básico a los datos crudos (raw) de la fuente TPC-DS.

    stg_raw__catalog_returns: Devoluciones del catálogo.

    stg_raw__catalog_sales: Ventas por catálogo.

    stg_raw__customer_address: Direcciones de clientes.

    stg_raw__customer_demogra: Datos demográficos de clientes.

    stg_raw__customer: Información principal de clientes.

    stg_raw__date_dim: Dimensión de fechas.

    stg_raw__household_demogra: Datos demográficos del hogar.

    stg_raw__inventory: Niveles de inventario.

    stg_raw__item: Catálogo de artículos/productos.

    stg_raw__store_returns: Devoluciones en tienda física.

    stg_raw__store_sales: Ventas en tienda física.

    stg_raw__store: Información de tiendas.

    stg_raw__warehouse: Información de almacenes.

    stg_raw__web_returns: Devoluciones vía web.

    stg_raw__web_sales: Ventas vía web.

2. Capa Intermedia (intermediate)

Modelos que unen (join) múltiples tablas de staging y aplican lógica de negocio compleja.

    int_customer_enriched: Perfil de cliente enriquecido con datos demográficos y de dirección.

    int_unified_returns: Unificación de todas las devoluciones (web, tienda, catálogo).

    int_unified_sales: Unificación de todos los canales de venta en una única visión transaccional.

3. Capa de Marts (marts)

Tablas finales optimizadas para el análisis y consumo en herramientas de BI (como Power BI).

    mart_customer_lifetime_value: Cálculo de métricas de valor de vida del cliente (CLV).

    mart_inventory_health: Análisis de rotación de stock, stockouts y salud de inventario.

    mart_sales_by_channel: Reporte agregado de ventas y rendimiento por canal de distribución.

## Decisiones de diseño personales

1. Tratamiento de datos ilógicos en el CLV

El enunciado no especificaba cómo manejar clientes con más devoluciones que compras. Por lo cual transformé los resultados negativos a 0 y limité el return_rate a un máximo de 1 (100%).

Debido a esta decisión se puede evitar que los KPIs globales de ingresos se vieran restados por datos que parecen errores de origen o casos atípicos, manteniendo la coherencia visual en el dashboard de Power BI.

2. Gestión de alertas en la calidad de datos (dbt tests)

En lugar de eliminar los registros con errores de lógica (donde las devoluciones superan las ventas), decidí mantenerlos en el modelo pero con un test de dbt configurado como warn.

En un entorno real, ocultar los datos impide que el equipo de origen corrija el error. Con el warn, el pipeline sigue funcionando pero deja rastro de que esos registros necesitan revisión.