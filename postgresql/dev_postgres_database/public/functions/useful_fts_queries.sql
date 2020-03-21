-- To search incoming string in a column
SELECT
	*
FROM
	<your_table>
WHERE
 (to_tsvector('spanish',UNACCENT(lower(<column_name>))) @@ to_tsquery('spanish',UNACCENT(lower(replace(trim(<param_string>) || ':*',' ','&')))))

/*
# Steps:
1. Remove white spaces at the begining or at the end with trim()

2. Append :*  at the end of the string to allow to search incomplete string

3. Replace space between multiple words with & to allow to search incomplete string with multiple words

4. Apply lower() function

5. Remove accents with UNACCENT(), previously installed with:
CREATE EXTENSION unaccent;

6. Remove (spanish) stop words with to_tsquery()

7. Match string with the column selected

* Important Note: consider that the column should have some index (GIN, GiST or B-tree, see more information here: https://www.postgresql.org/docs/current/textsearch-indexes.html) to make improvements in fast searches

* To check efficient of this query, use: 
EXPLAIN ANALYZE query

See important documentation below (according with your postgresql version):
- https://www.postgresql.org/docs/current/textsearch.html
- https://www.postgresql.org/docs/11/pgtrgm.html
- https://stackoverflow.com/questions/2513501/postgresql-full-text-search-how-to-search-partial-words

# Examples of Search:

SELECT
	*
FROM
	places
WHERE
 (to_tsvector('spanish',UNACCENT(lower(name))) @@ to_tsquery('spanish',UNACCENT(lower(replace(trim('ángel') || ':*',' ','&')))))


- First place: "El Salto Ángel"
- Searches:
ángel
angel
salto
El salto angel
El Salto Ángel
El Sal
salto a
s
sa
   sa

- Second place (with to_tsvector('english'): "The Wizarding World of Harry Potter" 
- Searches:
The Wizarding World of Harry Potter
Harry Potter
Potter
Pot
Potter Harry
w
wi

- Third place: "Triángulo de las Bermudas"
- Searches:
triángulo
el triángulo
bermudas

*/