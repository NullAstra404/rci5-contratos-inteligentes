// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RegistroDocumentos
 * @notice Contrato didactico para registrar, consultar y revocar
 *         identificadores de documentos durante el taller RCI 5.0.
 */
contract RegistroDocumentos {

    struct Documento {
        bytes32 hashDocumento;
        address propietario;
        uint256 fechaRegistro;
        bool vigente;
    }

    mapping(bytes32 => Documento) private documentos;

    event DocumentoRegistrado(
        bytes32 indexed hashDocumento,
        address indexed propietario,
        uint256 fechaRegistro
    );

    event DocumentoRevocado(
        bytes32 indexed hashDocumento,
        address indexed propietario
    );

    /**
     * @notice Genera un hash para realizar pruebas en Remix.
     * @dev En un sistema real, el hash del archivo normalmente
     *      se calcularia fuera de blockchain.
     */
    function calcularHash(
        string memory _texto
    )
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_texto));
    }

    /**
     * @notice Registra un documento identificado por su hash.
     */
    function registrarDocumento(
        bytes32 _hash
    )
        public
    {
        require(
            _hash != bytes32(0),
            "Hash no valido"
        );

        require(
            documentos[_hash].propietario == address(0),
            "Documento ya registrado"
        );

        documentos[_hash] = Documento({
            hashDocumento: _hash,
            propietario: msg.sender,
            fechaRegistro: block.timestamp,
            vigente: true
        });

        emit DocumentoRegistrado(
            _hash,
            msg.sender,
            block.timestamp
        );
    }

    /**
     * @notice Consulta los datos asociados a un documento.
     */
    function consultarDocumento(
        bytes32 _hash
    )
        public
        view
        returns (
            address propietario,
            uint256 fechaRegistro,
            bool vigente
        )
    {
        require(
            documentos[_hash].propietario != address(0),
            "Documento no registrado"
        );

        Documento memory doc = documentos[_hash];

        return (
            doc.propietario,
            doc.fechaRegistro,
            doc.vigente
        );
    }

    /**
     * @notice Revoca un documento previamente registrado.
     * @dev Solo la cuenta que registro el documento puede revocarlo.
     */
    function revocarDocumento(
        bytes32 _hash
    )
        public
    {
        require(
            documentos[_hash].propietario != address(0),
            "Documento no registrado"
        );

        require(
            documentos[_hash].propietario == msg.sender,
            "No autorizado"
        );

        require(
            documentos[_hash].vigente,
            "Documento ya revocado"
        );

        documentos[_hash].vigente = false;

        emit DocumentoRevocado(
            _hash,
            msg.sender
        );
    }
}
