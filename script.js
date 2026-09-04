// ============================================
// PROJECT CEB - SCRIPT.JS
// ============================================


// ============================================
// 1. MODO OSCURO
// ============================================

const darkMode = document.getElementById("darkMode");

if (darkMode) {

    darkMode.addEventListener("change", function () {

        document.body.classList.toggle("dark");

    });

}


// ============================================
// 2. ENVIAR EXCUSA
// ============================================

const formExcusa = document.getElementById("formExcusa");
const mensajeExito = document.getElementById("mensajeExito");

if (formExcusa) {

    formExcusa.addEventListener("submit", function (event) {

        event.preventDefault();

        // Limpiar formulario
        formExcusa.reset();

        // Mostrar mensaje
        if (mensajeExito) {

            mensajeExito.style.display = "block";

            // Ocultar después de 4 segundos
            setTimeout(function () {

                mensajeExito.style.display = "none";

            }, 4000);

        }

    });

}


// ============================================
// 3. BUSCADOR DE ESTUDIANTES
// ============================================

const documento = document.getElementById("documento");
const nombre = document.getElementById("nombre");

const nivel = document.getElementById("nivel");
const grado = document.getElementById("grado");
const curso = document.getElementById("curso");

const btnBuscar = document.getElementById("btnBuscar");

const tablaEstudiantes =
    document.getElementById("tablaEstudiantes");


// ============================================
// NIVEL → GRADO
// ============================================

if (nivel && grado && curso) {

    nivel.addEventListener("change", function () {

        const nivelSeleccionado = nivel.value;

        grado.innerHTML =
            '<option value="">Todos los grados</option>';

        curso.innerHTML =
            '<option value="">Todos los cursos</option>';

        curso.disabled = true;


        if (nivelSeleccionado === "") {

            grado.disabled = true;

            return;
        }


        grado.disabled = false;


        // PRIMARIA

        if (nivelSeleccionado === "primaria") {

            grado.innerHTML += `
                <option value="1°">Primero</option>
                <option value="2°">Segundo</option>
                <option value="3°">Tercero</option>
                <option value="4°">Cuarto</option>
                <option value="5°">Quinto</option>
            `;

        }


        // BACHILLERATO

        if (nivelSeleccionado === "bachillerato") {

            grado.innerHTML += `
                <option value="6°">Sexto</option>
                <option value="7°">Séptimo</option>
                <option value="8°">Octavo</option>
                <option value="9°">Noveno</option>
                <option value="10°">Décimo</option>
                <option value="11°">Undécimo</option>
            `;

        }

    });


    // ============================================
    // GRADO → CURSO
    // ============================================

    grado.addEventListener("change", function () {

        const gradoSeleccionado = grado.value;

        curso.innerHTML =
            '<option value="">Todos los cursos</option>';

        curso.disabled = true;


        if (gradoSeleccionado === "") {
            return;
        }


        const numeroGrado =
            gradoSeleccionado.replace("°", "");


        // =========================================
        // PRIMARIA
        // =========================================

        if (
            numeroGrado === "1" ||
            numeroGrado === "2" ||
            numeroGrado === "3" ||
            numeroGrado === "4" ||
            numeroGrado === "5"
        ) {

            for (let i = 1; i <= 5; i++) {

                const numeroCurso =
                    numeroGrado + "0" + i;

                curso.innerHTML += `
                    <option value="${numeroCurso}">
                        ${numeroCurso}
                    </option>
                `;

            }

        }


        // =========================================
        // BACHILLERATO
        // =========================================

        if (
            numeroGrado === "6" ||
            numeroGrado === "7" ||
            numeroGrado === "8" ||
            numeroGrado === "9"
        ) {

            for (let i = 1; i <= 7; i++) {

                const numeroCurso =
                    numeroGrado + "0" + i;

                curso.innerHTML += `
                    <option value="${numeroCurso}">
                        ${numeroCurso}
                    </option>
                `;

            }

        }


        // =========================================
        // DÉCIMO Y UNDÉCIMO
        // =========================================

        if (
            numeroGrado === "10" ||
            numeroGrado === "11"
        ) {

            for (let i = 1; i <= 7; i++) {

                const numeroCurso =
                    numeroGrado + "-0" + i;

                curso.innerHTML += `
                    <option value="${numeroCurso}">
                        ${numeroCurso}
                    </option>
                `;

            }

        }


        curso.disabled = false;

    });

}


// ============================================
// BUSCAR ESTUDIANTES
// ============================================

if (btnBuscar && tablaEstudiantes) {

    btnBuscar.addEventListener("click", function () {

        const documentoBuscado =
            documento ? documento.value.trim().toLowerCase() : "";

        const nombreBuscado =
            nombre ? nombre.value.trim().toLowerCase() : "";

        const nivelSeleccionado =
            nivel ? nivel.value.toLowerCase() : "";

        const gradoSeleccionado =
            grado ? grado.value.toLowerCase() : "";

        const cursoSeleccionado =
            curso ? curso.value.toLowerCase() : "";


        const filas =
            tablaEstudiantes.querySelectorAll("tr");


        filas.forEach(function (fila, indice) {

            if (indice === 0) {
                return;
            }


            const documentoFila =
                fila.cells[0].textContent
                    .trim()
                    .toLowerCase();

            const nombreFila =
                fila.cells[1].textContent
                    .trim()
                    .toLowerCase();

            const cursoFila =
            (fila.getAttribute("data-curso") || "")
            .trim()
            .toLowerCase();
        
            const gradoFila =
            (fila.getAttribute("data-grado") || "")
           .trim()
           .toLowerCase();

            const nivelFila =
            (fila.getAttribute("data-nivel") || "")
            .trim()
            .toLowerCase();


            let mostrar = true;


            // DOCUMENTO

            if (
                documentoBuscado !== "" &&
                !documentoFila.includes(documentoBuscado)
            ) {

                mostrar = false;

            }


            // NOMBRE

            if (
                nombreBuscado !== "" &&
                !nombreFila.includes(nombreBuscado)
            ) {

                mostrar = false;

            }


            // NIVEL

            if (
                nivelSeleccionado !== "" &&
                nivelFila !== nivelSeleccionado
            ) {

                mostrar = false;

            }


            // GRADO

            if (
                gradoSeleccionado !== "" &&
                gradoFila !== gradoSeleccionado
            ) {

                mostrar = false;

            }


            // CURSO

            if (
                cursoSeleccionado !== "" &&
                cursoFila !== cursoSeleccionado
            ) {

                mostrar = false;

            }


            fila.style.display =
                mostrar ? "" : "none";

        });

    });

}


// ============================================
// 4. FILTRAR EXCUSAS
// ============================================

const tipoExcusa =
    document.getElementById("tipoExcusa");

const fechaExcusa =
    document.getElementById("fechaExcusa");

const tablaExcusas =
    document.getElementById("tablaExcusas");


// ============================================
// FILTRAR EXCUSAS
// ============================================

function filtrarExcusas() {

    if (!tablaExcusas) {
        return;
    }


    const tipo =
        tipoExcusa ? tipoExcusa.value : "";

    const fecha =
        fechaExcusa ? fechaExcusa.value : "";

    const nivelSeleccionado =
    nivel ? nivel.value : "";

    const gradoSeleccionado =
    grado ? grado.value.replace("°", "") : "";


    const cursoSeleccionado =
    curso ? curso.value : "";

    const filas =
        tablaExcusas.querySelectorAll("tr");


    filas.forEach(function (fila, indice) {

        // Saltar encabezado

        if (indice === 0) {
            return;
        }


        // Datos de la fila

        const tipoFila =
            fila.cells[1].textContent.trim();

        const fechaFila =
            fila.cells[2].textContent.trim();

        const nivelFila =
            fila.getAttribute("data-nivel") || "";

        const gradoFila =
            fila.getAttribute("data-grado") || "";

        const cursoFila =
            fila.getAttribute("data-curso") || "";


        let mostrar = true;


        // =====================================
        // TIPO DE EXCUSA
        // =====================================

        if (
            tipo !== "" &&
            tipoFila !== tipo
        ) {

            mostrar = false;

        }


        // =====================================
        // FECHA
        // =====================================

        if (fecha !== "") {

            const partes =
                fecha.split("-");

            const fechaSeleccionada =
                partes[2] + "/" +
                partes[1] + "/" +
                partes[0];


            if (
                fechaFila !==
                fechaSeleccionada
            ) {

                mostrar = false;

            }

        }


        // =====================================
        // NIVEL
        // =====================================

        if (
            nivelSeleccionado !== "" &&
            nivelFila !== nivelSeleccionado
        ) {

            mostrar = false;

        }


        // =====================================
        // GRADO
        // =====================================

        if (
            gradoSeleccionado !== "" &&
            gradoFila !== gradoSeleccionado
        ) {

            mostrar = false;

        }


        // =====================================
        // CURSO
        // =====================================

        if (
            cursoSeleccionado !== "" &&
            cursoFila !== cursoSeleccionado
        ) {

            mostrar = false;

        }


        // MOSTRAR / OCULTAR

        fila.style.display =
            mostrar ? "" : "none";

    });

}

// ============================================
// FILTRO DE EXCUSAS NO ACEPTADAS
// ============================================

const filtroTipo = document.getElementById("filtroTipo");
const filtroNivel = document.getElementById("filtroNivel");
const filtroGrado = document.getElementById("filtroGrado");
const filtroCurso = document.getElementById("filtroCurso");
const btnBuscarNOExcusas =
    document.getElementById("btnBuscarNOExcusas");
const tablaNOExcusas = document.getElementById("tablaNOExcusas");


// ============================================
// NIVEL → GRADO
// ============================================

if (filtroNivel) {

    filtroNivel.addEventListener("change", function () {

        const nivelSeleccionado = filtroNivel.value;

        // Reiniciar grado y curso
        filtroGrado.innerHTML =
            '<option value="">Todos</option>';

        filtroCurso.innerHTML =
            '<option value="">Todos</option>';

        filtroCurso.disabled = true;


        // Si no selecciona nivel
        if (nivelSeleccionado === "") {

            filtroGrado.disabled = true;

            return;
        }


        filtroGrado.disabled = false;


        // PRIMARIA
        if (nivelSeleccionado === "Primaria") {

            filtroGrado.innerHTML += `
                <option value="1°">Primero</option>
                <option value="2°">Segundo</option>
                <option value="3°">Tercero</option>
                <option value="4°">Cuarto</option>
                <option value="5°">Quinto</option>
            `;
        }


        // BACHILLERATO
        if (nivelSeleccionado === "Bachillerato") {

            filtroGrado.innerHTML += `
                <option value="6°">Sexto</option>
                <option value="7°">Séptimo</option>
                <option value="8°">Octavo</option>
                <option value="9°">Noveno</option>
                <option value="10°">Décimo</option>
                <option value="11°">Undécimo</option>
            `;
        }

    });

}


// ============================================
// GRADO → CURSO
// ============================================

if (filtroGrado) {

    filtroGrado.addEventListener("change", function () {

        const gradoSeleccionado = filtroGrado.value;

        filtroCurso.innerHTML =
            '<option value="">Todos</option>';

        filtroCurso.disabled = true;


        if (gradoSeleccionado === "") {
            return;
        }


        filtroCurso.disabled = false;


        const numeroGrado =
            gradoSeleccionado.replace("°", "");


        // Crear cursos
        for (let i = 1; i <= 7; i++) {

            let numeroCurso;

            if (i < 10) {
                numeroCurso = numeroGrado + "0" + i;
            } else {
                numeroCurso = numeroGrado + i;
            }

            filtroCurso.innerHTML += `
                <option value="${numeroCurso}">
                    ${numeroCurso}
                </option>
            `;
        }

    });

}


// ============================================
// BUSCAR
// ============================================

if (btnBuscarNOExcusas) {

    btnBuscarNOExcusas.addEventListener("click", function () {

        const tipoSeleccionado =
            filtroTipo.value;

        const nivelSeleccionado =
            filtroNivel.value;

        const gradoSeleccionado =
            filtroGrado.value;

        const cursoSeleccionado =
            filtroCurso.value;


        const filas =
            tablaNOExcusas.querySelectorAll("tr");


        // Recorrer las filas
        filas.forEach(function (fila, indice) {

            // Saltar encabezado
            if (indice === 0) {
                return;
            }


            const tipoFila =
                fila.dataset.tipo;

            const nivelFila =
                fila.dataset.nivel;

            const gradoFila =
                fila.dataset.grado;

            const cursoFila =
                fila.dataset.curso;


            let mostrar = true;


            // FILTRAR TIPO
            if (
                tipoSeleccionado !== "" &&
                tipoFila !== tipoSeleccionado
            ) {
                mostrar = false;
            }


            // FILTRAR NIVEL
            if (
                nivelSeleccionado !== "" &&
                nivelFila !== nivelSeleccionado
            ) {
                mostrar = false;
            }


            // FILTRAR GRADO
            if (
                gradoSeleccionado !== "" &&
                gradoFila !== gradoSeleccionado
            ) {
                mostrar = false;
            }


            // FILTRAR CURSO
            if (
                cursoSeleccionado !== "" &&
                cursoFila !== cursoSeleccionado
            ) {
                mostrar = false;
            }


            // MOSTRAR / OCULTAR
            fila.style.display =
                mostrar ? "" : "none";

        });

    });

}

// ============================================
// BUSCAR ACUDIENTES POR DOCUMENTO Y NOMBRE
// ============================================

const documentoAcudiente = document.getElementById("documentoAcudiente");
const nombreAcudiente = document.getElementById("nombreAcudiente");
const btnBuscarAcudiente = document.getElementById("btnBuscarAcudiente");
const tablaAcudientes = document.getElementById("tablaAcudientes");


if (btnBuscarAcudiente) {

    btnBuscarAcudiente.addEventListener("click", function () {

        const documentoBuscado =
            documentoAcudiente.value.trim().toLowerCase();

        const nombreBuscado =
            nombreAcudiente.value.trim().toLowerCase();

        const filas =
            tablaAcudientes.querySelectorAll("tr");

        filas.forEach(function (fila, indice) {

            // Saltar encabezado
            if (indice === 0) {
                return;
            }

            const documentoFila =
                fila.cells[0].textContent
                    .trim()
                    .toLowerCase();

            const nombreFila =
                fila.cells[1].textContent
                    .trim()
                    .toLowerCase();

            let mostrar = true;

            // FILTRAR DOCUMENTO
            if (
                documentoBuscado !== "" &&
                !documentoFila.includes(documentoBuscado)
            ) {
                mostrar = false;
            }

            // FILTRAR NOMBRE
            if (
                nombreBuscado !== "" &&
                !nombreFila.includes(nombreBuscado)
            ) {
                mostrar = false;
            }

            fila.style.display = mostrar ? "" : "none";

        });

    });

}

// ============================================
// FILTROS - EXCUSAS ACEPTADAS
// ============================================

const tipoAceptadas =
    document.getElementById("filtroTipoAceptadas");

const nivelAceptadas =
    document.getElementById("filtroNivelAceptadas");

const gradoAceptadas =
    document.getElementById("filtroGradoAceptadas");

const cursoAceptadas =
    document.getElementById("filtroCursoAceptadas");

const botonAceptadas =
    document.getElementById("btnBuscarAceptadas");

const tablaAceptadas =
    document.getElementById("tablaAceptadas");


// ============================================
// NIVEL → GRADO
// ============================================

if (nivelAceptadas) {

    nivelAceptadas.addEventListener("change", function () {

        const nivel = this.value;


        // Limpiar grado
        gradoAceptadas.innerHTML =
            '<option value="">Selecciona un grado</option>';


        // Limpiar curso
        cursoAceptadas.innerHTML =
            '<option value="">Selecciona un curso</option>';


        // Desactivar curso
        cursoAceptadas.disabled = true;


        // Si no selecciona nivel
        if (nivel === "") {

            gradoAceptadas.disabled = true;

            return;
        }


        // Activar grado
        gradoAceptadas.disabled = false;


        // PRIMARIA
        if (nivel === "Primaria") {

            gradoAceptadas.innerHTML += `
                <option value="1°">Primero</option>
                <option value="2°">Segundo</option>
                <option value="3°">Tercero</option>
                <option value="4°">Cuarto</option>
                <option value="5°">Quinto</option>
            `;

        }


        // BACHILLERATO
        if (nivel === "Bachillerato") {

            gradoAceptadas.innerHTML += `
                <option value="6°">Sexto</option>
                <option value="7°">Séptimo</option>
                <option value="8°">Octavo</option>
                <option value="9°">Noveno</option>
                <option value="10°">Décimo</option>
                <option value="11°">Undécimo</option>
            `;

        }

    });

}


// ============================================
// GRADO → CURSO
// ============================================

if (gradoAceptadas) {

    gradoAceptadas.addEventListener("change", function () {

        const grado = this.value;


        cursoAceptadas.innerHTML =
            '<option value="">Todos los cursos</option>';

        cursoAceptadas.disabled = true;


        if (grado === "") {
            return;
        }


        const numeroGrado = grado.replace("°", "");


        // ====================================
        // CURSOS
        // ====================================

        for (let i = 1; i <= 7; i++) {

            const numeroCurso =
                numeroGrado + "0" + i;

            cursoAceptadas.innerHTML += `
                <option value="${numeroCurso}">
                    ${numeroCurso}
                </option>
            `;

        }


        cursoAceptadas.disabled = false;

    });

}


// ============================================
// BOTÓN BUSCAR
// ============================================

if (botonAceptadas) {

    botonAceptadas.addEventListener("click", function () {

        const tipo = tipoAceptadas.value;
        const nivel = nivelAceptadas.value;
        const grado = gradoAceptadas.value;
        const curso = cursoAceptadas.value;


        const filas =
            tablaAceptadas.getElementsByTagName("tr");


        // Recorrer filas
        for (let i = 1; i < filas.length; i++) {

            const fila = filas[i];


            const tipoFila =
                fila.cells[0].textContent.trim();

            const nivelFila =
                fila.getAttribute("data-nivel");

            const gradoFila =
                fila.getAttribute("data-grado");

            const cursoFila =
                fila.getAttribute("data-curso");


            let mostrar = true;


            // TIPO
            if (
                tipo !== "" &&
                tipoFila !== tipo
            ) {

                mostrar = false;

            }


            // NIVEL
            if (
                nivel !== "" &&
                nivelFila !== nivel
            ) {

                mostrar = false;

            }


            // GRADO
            if (
                grado !== "" &&
                gradoFila !== grado
            ) {

                mostrar = false;

            }


            // CURSO
            if (
                curso !== "" &&
                cursoFila !== curso
            ) {

                mostrar = false;

            }


            // Mostrar / ocultar
            fila.style.display =
                mostrar ? "" : "none";

        }

    });

}

// ================================
// CERRAR SESIÓN
// ================================

function cerrarSesion() {

    let confirmar = confirm("¿Seguro que deseas cerrar sesión?");

    if (confirmar) {
        window.location.href = "index.html";
    }

}

document.addEventListener("DOMContentLoaded", function () {

    const password = document.getElementById("password");
    const mostrarPassword = document.getElementById("mostrarPassword");

    mostrarPassword.addEventListener("change", function () {

        if (this.checked) {
            password.type = "text";
        } else {
            password.type = "password";
        }

    });

});