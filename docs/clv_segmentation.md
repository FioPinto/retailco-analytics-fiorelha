## CLV segmentation methodology

Se ha utilizado `PERCENTILE_CONT` para dividir la distribución de CLV en tres segmentos:

- Bajo: ≤ percentil 33
- Medio: entre percentil 33 y 66
- Alto: > percentil 66

Justificación:
- La distribución de CLV está sesgada a la derecha
- NTILE se descartó como método final porque no respeta la magnitud absoluta del valor
- Percentiles permiten segmentación basada en valor económico real