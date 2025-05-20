include "catalogosINE";

# Transform the INE files to a format that can be digested by Postgres
[
. as $root 
| $root.candidatos[]
| . as $candidato
|
    {
        idCandidato: .idCandidato,
        cargo: get_cargo($candidato.idTipoCandidatura),
        municipio: "",
        state: $candidato.idEstadoEleccion,
        distrito: ($candidato.idDistritoJudicial // null),
        circuito: ($candidato.idCircuito // null),
        noLista: $candidato.numListaBoleta,
        rangoEdad: "N/A",
        actorPolitico: get_poder($candidato.poderPostula[0]).appPoderId,
        propietario: $candidato.nombreCandidato,
        suplente: "",
        suplenteID: "",
        imagenPartido: "N/A",
        materia: get_matter_uuid($candidato.especialidad // "NA"),
        numeroUnicoBoleta: $candidato.numListaBoleta,
        sexo: get_sexo($candidato.sexo),
        datosGenerales: {
                nombre: $candidato.nombreCandidato,
                cargo: get_cargo($candidato.idTipoCandidatura),
                edad: get_age($candidato.fechaNacimiento),
                sexo: get_sexo($candidato.sexo),
                numeroBoleta: $candidato.numListaBoleta,
                direccion: "",
                paginaWeb: $candidato.paginaWeb
        },

        mediosDeContacto: {
                telefono: $candidato.telefonoPublico,
                correo: $candidato.correoElecPublico,
                redesSociales: ($root.redesSociales | map(select(.idCandidato == $candidato.idCandidato).descripcionRed))
        },

       extras: [
         {
           question: "¿Por qué quiero ocupar un cargo público?",
           answer: $candidato.descripcionCandidato
         },
         {
           question: "Visión de la función jurisdiccional",
           answer: $candidato.visionJurisdiccional
         },
         {
           question: "Visión de la impartición de justicia",
           answer: $candidato.visionImparticionJusticia
         },
         {
           question: "Trayectoria académica",
           answer: $candidato.descripcionTP
         },
         {
           question: "Propuesta 1",
           answer: $candidato.propuesta1
         },
         {
           question: "Propuesta 2",
           answer: $candidato.propuesta2
         },
         {
           question: "Grado máximo de estudios",
           answer: get_estudios($candidato.idGrado)
         }
       ],
       # Some entries don't have the urlFoto field, sanitizing...
       imageUrl: "https://candidaturaspoderjudicial.ine.mx\(($candidato.urlFoto // "") | sub("/media"; ""))",
       curriculumUrl: "https://candidaturaspoderjudicial.ine.mx/cycc/documentos/cv/\($candidato.descripcionHLC)",
       videoUrl: null,
       candidatoUrl: "https://candidaturaspoderjudicial.ine.mx/detalleCandidato/\($candidato.idCandidato)/\($candidato.idTipoCandidatura)"

    }
]
|
.[]

