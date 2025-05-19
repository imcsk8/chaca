================================
Import JSON payloads to database
================================

.. code-block::bash

  user@host federales$ psql $DSN poder_judicial # or whatever the database is named
  poder_judicial => \i import_estados_circuitos.sql
  ...
  poder_judicial => \i import_federal_candidatos.sql
  

