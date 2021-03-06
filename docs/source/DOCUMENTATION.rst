Documentation on SQL script setup for proper Read The Docs parsing
==================================================================

Purpose
-------------

This document describes the requirements for properly formatting the SQL build scripts for this dataset to allow the automated parsing of these scripts by Read The Docs system and correctly generating the tables for the Aerial Surveys Data Dictionary.

File Structure
------------------

* The SQL scripts which build schema must be contained in a /sql folder in the root repository. 
* Two files are also needed in the root directory: requirements-docs.txt and setup.py.
* All other files needed for the automated Read The Docs system should be located in the /docs/source/ folders.
* The _static folder is where logos, custom css and images are stored.
* The SQL scripts which build schema must also have a name with the format "<name>_schema.sql"
* The /sql folder can contain subfolders with additional schema sql build files

.. code-block:: sql

   /nz-imagery-surveys/sql
   /nz-imagery-surveys/requirements-docs.txt
   /nz-imagery-surveys/setup.py
   /nz-imagery-surveys/docs/source/
   /nz-imagery-surveys/docs/source/_static



Files required
------------------

* Within the /nz-imagery-surveys/docs/source/ folder, there must be an .rst file for each schema being parsed, with a name format of "<schema name>_schema.rst". 
* On the first line of each schema .rst file, there should be a line as shown here to give the file a name for referencing:

::

   .. _aerial_lds_schema:

* An index.rst file must exist with the names of the above mentioned schema .rst files listed in the toctree without the .rst extension:

::

   .. toctree::
      :maxdepth: 3
      :numbered:

      introduction
      published_data
      internal_data

* any .rst files named in the toctree above must exist in the /docs/source/ folder (ie introduction, published_data, etc)
* a conf.py file containing setup and parsing scripts must be located in the /docs/source/ folder.

Structure requirements of SQL schema build files:

1. The SQL scripts which build schema must have a name with the format "<name>_schema.sql"

2. Tables must be created with the following structure, and lines must end with an opening "(" bracket, and schema name and schema table name separated by a period:

.. code-block:: sql

 CREATE TABLE IF NOT EXISTS buildings.lifecycle_stage (

3. Each table's columns must be listed in the lines immediately following the CREATE TABLE IF NOT EXISTS line, and within "()" brackets and ending with a semi-colon. It's important that each column be preceeded by four spaces, and then a comma "    ,". This is to ensure parsing is not confused by the comma used in the numeric or decimal precision/scope values.

.. code-block:: sql

   CREATE TABLE IF NOT EXISTS aerial_lds.imagery_survey_index (
      imagery_survey_id serial PRIMARY KEY
    , name text NOT NULL
    , imagery_id integer
    , index_id integer
    , set_order integer
    , ground_sample_distance decimal(6, 4)
    , accuracy text
    , supplier text
    , licensor text
    , flown_from date CONSTRAINT after_first_flight CHECK (flown_from > '1903-12-17')
    , flown_to date CONSTRAINT survey_completed CHECK (flown_to < now())
    , survey_added date NOT NULL
    , imagery_added date
    , imagery_modified date
    , imagery_removed date
    , shape public.geometry(MultiPolygon, 2193) NOT NULL
    , CONSTRAINT valid_flight_dates CHECK (flown_from <= flown_to)
    , CONSTRAINT valid_add_to_modify CHECK (imagery_added <= imagery_modified)
    , CONSTRAINT valid_add_to_remove CHECK (imagery_added <= imagery_removed));
    

4. Every schema, table, and column must have a comment describing it.

5. Schema and table and column comments should be formatted as below, ending with a semi-colon, and multiple lines can exist:

.. code-block:: sql

   COMMENT ON SCHEMA buildings IS 'The schema holds builing information. ';

   COMMENT ON TABLE buildings.lifecycle_stage IS
   'Lookup table that holds all of the lifecycle stages for a building.';

   COMMENT ON COLUMN buildings.buildings.begin_lifespan IS
   'The date that the building was first captured in the system.'
   ' This column cannot be null.';

6. Avoid using commas in any comments.

7. Numeric data types can have precision or scale values as single or double digits, but there cannot be a space in front of single digit precision values, and must have a space after the comma before the scale value, regardless of whether the scale value is single or double digit.

.. code-block:: sql

   CREATE TABLE IF NOT EXISTS buildings_bulk_load.related (
    area_bulk_load numeric(10, 2) NOT NULL,
    area_existing numeric(20, 12) NOT NULL,
    area_overlap numeric(8, 2) NOT NULL
    );

8. For table column comments which are foreign keys, they can either be written like 
	"Foreign key to the schema.table table",   or
	"Unique identifier for the schema.tablename table and foreign key to the schema.table table."
	The important part for the parsing script is the "foreign key to the " followed by "table", and the schema/table part must be separated by a period. This allows the script to correctly parse the schema and table name and link to the appropriate page containing that column reference.

9. The in order for the parsing linking to work, the names of the schema must be known in advance, and rst pages setup in advance according
to the names of the schema. This must be hard coded into the index.rst file, and appropriate links to pages setup. Therefore, the hyperlink to a table in item 8 above requires you to know the URL of the path to the appropriate schema pages in advance.
For example, an URL anchor link to the building_outlines table in the buildings schema will look like this:

.. code-block:: sql

   https://building-outlines-test.readthedocs.io/en/latest/buildings_schema.html#table-name-building-outlines

The above hyperlink is only shown to help understand the structure of the hyperlinks. The parsing script automatically determines the schema and table names.



