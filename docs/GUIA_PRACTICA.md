# Guía práctica — RegistroDocumentos

Esta guía resume el flujo que se realizará durante el tutorial **Desarrollo de Contratos Inteligentes y Aplicaciones Descentralizadas — RCI 5.0**.

## 1. Abrir el contrato

Abre `contracts/RegistroDocumentos.sol` en Remix IDE.

## 2. Compilar

1. Abre **Solidity Compiler**.
2. Utiliza un compilador compatible con `pragma solidity ^0.8.20;`.
3. Selecciona **Compile RegistroDocumentos.sol**.
4. Verifica que no existan errores.

## 3. Desplegar

1. Abre **Deploy & Run Transactions**.
2. Selecciona **Remix VM** como entorno.
3. Mantén `Value = 0`.
4. Selecciona la primera cuenta disponible. La llamaremos **Cuenta A**.
5. Despliega `RegistroDocumentos`.

## 4. Generar un hash de prueba

Ejecuta:

```text
calcularHash("Documento-RCI-001")
```

Copia el valor `bytes32` devuelto por Remix.

## 5. Registrar el documento

Con **Cuenta A**, ejecuta:

```text
registrarDocumento(HASH)
```

La operación genera una transacción y emite el evento `DocumentoRegistrado`.

## 6. Consultar

Ejecuta:

```text
consultarDocumento(HASH)
```

Debes obtener:

```text
propietario   = direccion de Cuenta A
fechaRegistro = timestamp
vigente       = true
```

## 7. Probar el control de acceso

Cambia a una segunda cuenta en Remix. La llamaremos **Cuenta B**.

Intenta ejecutar:

```text
revocarDocumento(HASH)
```

La transacción debe revertirse con:

```text
No autorizado
```

Esto ocurre porque el contrato comprueba:

```solidity
documentos[_hash].propietario == msg.sender
```

## 8. Revocar correctamente

Vuelve a **Cuenta A** y ejecuta:

```text
revocarDocumento(HASH)
```

La transacción debe completarse correctamente y emitir `DocumentoRevocado`.

## 9. Comprobar el estado final

Ejecuta nuevamente:

```text
consultarDocumento(HASH)
```

Ahora el resultado esperado es:

```text
vigente = false
```

## 10. Observar Remix

Durante la práctica revisa:

- dirección del contrato;
- cuenta que ejecuta cada transacción;
- historial de transacciones;
- eventos emitidos;
- consumo de gas;
- diferencia entre **Call** y **Transact**.

## Resultado esperado

Al finalizar habrás probado en una EVM local:

```text
Cuenta A
   |
   +-- registrarDocumento()  -> exito
   |
   +-- consultarDocumento() -> vigente = true

Cuenta B
   |
   +-- revocarDocumento()   -> No autorizado

Cuenta A
   |
   +-- revocarDocumento()   -> exito
   |
   +-- consultarDocumento() -> vigente = false
```

> Remix VM utiliza cuentas y ETH ficticios. No se utiliza dinero real.
