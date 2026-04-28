# Column Mapping - int_unified_sales

Este documento describe las decisiones de unificación de columnas realizadas para construir el modelo `int_unified_sales`, que integra las ventas de los canales:

- Store Sales
- Catalog Sales
- Web Sales


---

## 1. Claves de negocio

### order_id

Se unifica la clave de negocio de pedidos bajo el campo `order_id`:

| Fuente | Columna original |
|--------|------------------|
| store_sales | ticket_number |
| catalog_sales | order_number |
| web_sales | order_number |

**Decisión:**
Se estandariza como `order_id` para permitir trazabilidad de transacciones independientemente del canal.

---

## 2. Cliente (customer_sk)

La definición de cliente varía según el canal:

| Canal | Columna usada |
|------|---------------|
| store | customer_sk |
| catalog | ship_customer_sk |
| web | bill_customer_sk |

**Decisión:**
- En store: cliente directo de la transacción.
- En catalog: cliente de envío (ship_customer_sk).
- En web: cliente de facturación (bill_customer_sk).

Esta decisión permite mantener coherencia analítica en comportamiento de compra por canal.

---

## 3. Store / Warehouse / Web Site

### store_sk
Solo aplica al canal store.

### warehouse_sk
Aplica a catalog_sales y web_sales.

### web_site_sk
Solo aplica al canal web.

**Decisión:**
Se mantienen como dimensiones específicas por canal y se dejan en NULL cuando no aplican.

---

## 4. Sales_channel

Se crea una nueva columna derivada:

| Canal origen | Valor |
|-------------|------|
| store_sales | 'store' |
| catalog_sales | 'catalog' |
| web_sales | 'web' |

**Decisión:**
Permite segmentación directa en análisis de rendimiento por canal.

---

## 5. Métricas de ventas

Las métricas se estandarizan entre las tres fuentes:

| Métrica | Tratamiento |
|--------|------------|
| quantity | Directo |
| net_paid | Directo |
| net_profit | Directo |
| discount_amount | Normalizado |
| tax | Normalizado |

**Decisión:**
Se armonizan nombres y significado para permitir comparabilidad entre canales.

---

## 6. Unificación de estructura

Se define un esquema común con:

- date_sk
- time_sk
- item_sk
- customer_sk
- order_id
- sales_channel
- métricas económicas

**Decisión:**
Se prioriza consistencia semántica sobre estructura original de cada tabla.

---

## 7. Estrategia técnica

Se utiliza `UNION ALL` en lugar de `UNION`:

**Motivo:**
- Evita deduplicación innecesaria
- Mejora rendimiento
- Las fuentes ya son disjuntas por canal