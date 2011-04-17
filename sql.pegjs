// originally generated by pegjs, from tmp/rules.rb and bubble-to-pegjs_ex.rb
// and manually edited for pegjs suitability.  Rules with indentation
// or with comments have manual edits.
//
{
  function flatten(x, rejectSpace, acc) {
    acc = acc || [];
    if ((x.length == undefined) || // Just an object, not a string or array.
        (!rejectSpace ||
         (typeof(x) != "string" ||
          !x.match(/^\s*$/)))) {
      acc[acc.length] = x;
      return acc;
    }
    for (var i = 0; i < x.length; i++) {
      flatten(x[i], rejectSpace, acc);
    }
    return acc;
  }
  function flatstr(x, rejectSpace, joinChar) {
    return flatten(x, rejectSpace, []).join(joinChar || '');
  }
}

start = sql_stmt_list

sql_stmt_list =
  ( whitespace ( sql_stmt )? whitespace semicolon )+

sql_stmt =
  ( explain: ( EXPLAIN ( QUERY PLAN )? )?
    stmt: (
//    alter_table_stmt
//    / analyze_stmt
//    / attach_stmt
//    / begin_stmt / commit_stmt
//    / create_index_stmt
      create_table_stmt
//    / create_trigger_stmt
//    / create_view_stmt
//    / create_virtual_table_stmt
      / delete_stmt / delete_stmt_limited
//    / detach_stmt / drop_index_stmt / drop_table_stmt / drop_trigger_stmt / drop_view_stmt
      / insert_stmt
//    / pragma_stmt / reindex_stmt / release_stmt / rollback_stmt / savepoint_stmt
      / select_stmt
      / update_stmt / update_stmt_limited
//    / vacuum_stmt
    ) )
  { return { explain: flatstr(explain), stmt: stmt } }

alter_table_stmt =
( ( ALTER TABLE ( database_name dot )? table_name ) ( RENAME TO new_table_name ) ( ADD ( COLUMN )? column_def ) )

analyze_stmt =
  ( ANALYZE ( database_name / table_or_index_name / ( database_name dot table_or_index_name ) )? )

attach_stmt =
  ( ATTACH ( DATABASE )? expr AS database_name )

begin_stmt =
  ( BEGIN ( DEFERRED / IMMEDIATE / EXCLUSIVE )? ( TRANSACTION )? )

commit_stmt =
( ( COMMIT / END ) ( TRANSACTION )? )

rollback_stmt =
( ROLLBACK ( TRANSACTION )? ( TO ( SAVEPOINT )? savepoint_name )? )

savepoint_stmt =
( SAVEPOINT savepoint_name )

release_stmt =
( RELEASE ( SAVEPOINT )? savepoint_name )

create_index_stmt =
( ( CREATE ( UNIQUE )? INDEX ( IF NOT EXISTS )? ) ( ( database_name dot )? index_name ON table_name lparen ( indexed_column comma )+ rparen ) )

indexed_column =
  ( column_name ( COLLATE collation_name )? ( ASC / DESC )? )

create_table_stmt =
  ( CREATE ( TEMP / TEMPORARY )? TABLE ( IF NOT EXISTS )? )
  ( ( database_name dot )? table_name
    ( lparen ( column_def comma )+ ( comma table_constraint )+ rparen )
    ( AS select_stmt ) )

column_def =
  ( column_name ( type_name )? ( column_constraint )+ )

type_name =
  ( name )+ ( ( lparen signed_number rparen ) / ( lparen signed_number comma signed_number rparen ) )?

column_constraint =
  ( ( CONSTRAINT name )?
    ( ( PRIMARY KEY ( ASC / DESC )? conflict_clause ( AUTOINCREMENT )? )
    / ( NOT NULL conflict_clause )
    / ( UNIQUE conflict_clause )
    / ( CHECK lparen expr rparen )
    / ( DEFAULT ( signed_number / literal_value / ( lparen expr rparen ) ) )
    / ( COLLATE collation_name )
    / foreign_key_clause ) )

signed_number =
  ( ( plus / minus )? numeric_literal )

table_constraint =
( ( CONSTRAINT name )? ( ( ( ( PRIMARY KEY ) / UNIQUE ) lparen ( indexed_column comma )+ rparen conflict_clause ) / ( CHECK lparen expr rparen ) / ( FOREIGN KEY lparen ( column_name comma )+ rparen foreign_key_clause ) ) )

foreign_key_clause =
  ( ( REFERENCES foreign_table ( lparen ( column_name comma )+ rparen )? )
    ( ( ( ON ( DELETE / UPDATE )
             ( ( SET NULL )
             / ( SET DEFAULT )
             / CASCADE
             / RESTRICT
             / ( NO ACTION ) ) )
         / ( MATCH name ) )+ )?
    ( ( NOT )? DEFERRABLE ( ( INITIALLY DEFERRED ) / ( INITIALLY IMMEDIATE ) )? )? )

conflict_clause =
( ( ON CONFLICT ( ROLLBACK / ABORT / FAIL / IGNORE / REPLACE ) ) )?

create_trigger_stmt =
  ( ( CREATE ( TEMP / TEMPORARY )? TRIGGER ( IF NOT EXISTS )? )
    ( ( database_name dot )? trigger_name ( BEFORE / AFTER / ( INSTEAD OF ) )? )
    ( ( DELETE / INSERT / ( UPDATE ( OF ( column_name comma )+ )? ) ) ON table_name )
    ( ( FOR EACH ROW )? ( WHEN expr )? )
    ( BEGIN ( ( update_stmt / insert_stmt / delete_stmt / select_stmt ) semicolon )+ END ) )

create_view_stmt =
  ( ( CREATE ( TEMP / TEMPORARY )? VIEW ( IF NOT EXISTS )? )
    ( ( database_name dot )? view_name AS select_stmt ) )

create_virtual_table_stmt =
( ( CREATE VIRTUAL TABLE ( database_name dot )? table_name ) ( USING module_name ( lparen ( module_argument comma )+ rparen )? ) )

delete_stmt =
  ( DELETE FROM qualified_table_name ( WHERE expr )? )

delete_stmt_limited =
  ( DELETE FROM qualified_table_name ( WHERE expr )?
    ( ( ( ORDER BY ( ordering_term comma )+ )? ( LIMIT expr ( ( OFFSET / comma ) expr )? ) ) )? )

detach_stmt =
( DETACH ( DATABASE )? database_name )

drop_index_stmt =
( DROP INDEX ( IF EXISTS )? ( database_name dot )? index_name )

drop_table_stmt =
( DROP TABLE ( IF EXISTS )? ( database_name dot )? table_name )

drop_trigger_stmt =
( DROP TRIGGER ( IF EXISTS )? ( database_name dot )? trigger_name )

drop_view_stmt =
( DROP VIEW ( IF EXISTS )? ( database_name dot )? view_name )

value =
  ( whitespace
    value: (
      literal_value
    / bind_parameter
    / ( ( ( database_name dot )? table_name dot )? column_name )
    / ( unary_operator expr )
    / ( function_name lparen ( ( DISTINCT ? ( expr comma )+ ) / star )? rparen )
    / ( lparen expr rparen )
    / ( CAST lparen expr AS type_name rparen )
    / ( ( NOT ? EXISTS )? lparen select_stmt rparen )
    / ( CASE expr ? ( WHEN expr THEN expr )+ ( ELSE expr )? END )
    / raise_function ) )
  { return { value: value } }

expr =
  ( whitespace
    ( ( value binary_operator expr )
    / ( value COLLATE collation_name )
    / ( value NOT ? ( LIKE / GLOB / REGEXP / MATCH ) expr ( ESCAPE expr )? )
    / ( value ( ISNULL / NOTNULL / ( NOT NULL ) ) )
    / ( value IS NOT ? expr )
    / ( value NOT ? BETWEEN expr AND expr )
    / ( value NOT ? IN ( ( lparen ( select_stmt / ( expr comma )+ )? rparen )
                     / ( ( database_name dot )? table_name ) ) )
    / value ) )

raise_function =
( RAISE lparen ( IGNORE / ( ( ROLLBACK / ABORT / FAIL ) comma error_message ) ) rparen )

literal_value =
( numeric_literal / string_literal / blob_literal / NULL / CURRENT_TIME / CURRENT_DATE / CURRENT_TIMESTAMP )

numeric_literal =
  ( ( ( ( digit )+ ( decimal_point ( digit )+ )? )
      / ( decimal_point ( digit )+ ) ) ( E ( plus / minus )? ( digit )+ )? )

insert_stmt =
( ( ( ( INSERT ( OR ( ROLLBACK / ABORT / REPLACE / FAIL / IGNORE ) )? ) / REPLACE ) INTO ( database_name dot )? table_name ) ( ( lparen ( column_name comma )+ rparen )? ( VALUES lparen ( expr comma )+ rparen ) select_stmt ) ( DEFAULT VALUES ) )

pragma_stmt =
  ( PRAGMA ( database_name dot )? pragma_name
    ( ( equal pragma_value ) / ( lparen pragma_value rparen ) )? )

pragma_value =
( signed_number / name / string_literal )

reindex_stmt =
  ( REINDEX collation_name ( ( database_name dot )? table_name index_name ) )

select_stmt =
  ( select_core: ( select_core (compound_operator select_core )* )
    order_by: ( ( ORDER BY ordering_term (whitespace comma ordering_term)* )? )
    limit: ( ( LIMIT expr ( ( OFFSET / comma ) expr )? )? ) )
  { return { select_core: select_core,
             order_by: order_by,
             limit: limit } }

select_core =
  ( SELECT d: ( ( DISTINCT / ALL )? )
           c: ( result_column ( whitespace comma result_column )* )
    f: ( ( FROM join_source )? )
    w: ( ( WHERE expr )? )
    g: ( GROUP BY ( ordering_term comma )+ ( HAVING expr )? )? )
  { return { distinct: flatstr(d),
             columns: c,
             from: f,
             where: w,
             group_by: g } }

result_column =
  ( whitespace
    ( star
      / ( table_name dot star )
      / ( expr ( AS ? column_alias )? ) ) )

join_source =
  ( single_source ( ( join_op single_source join_constraint )+ )? )

single_source =
  ( whitespace
    ( ( t: ( ( database_name dot )? table_name )
        a: ( ( AS ? table_alias )? )
        i: ( ( ( INDEXED BY index_name )
              / ( NOT INDEXED ) )? ) )
        { return { table: flatstr(t, true),
                   alias: flatstr(a, true),
                   index: flatstr(i, true) } }
      / ( lparen s: select_stmt rparen a: ( AS ? table_alias )? )
        { return { select: flatstr(s, true),
                   alias: flatstr(a, true) } }
      / ( lparen j: join_source rparen )
        { return j }
    ) )

join_op =
  ( whitespace
    ( comma
    / ( NATURAL ?
        ( ( LEFT ( OUTER ) ? ) / INNER / CROSS )? JOIN ) ) )

join_constraint =
  ( ( ( ON expr )
    / ( USING lparen ( column_name comma )+ rparen ) )? )

ordering_term =
  ( whitespace
    ( expr ( COLLATE collation_name )? ( ASC / DESC )? ) )

compound_operator =
  ( ( UNION ALL ? )
  / INTERSECT
  / EXCEPT )

update_stmt =
  ( ( UPDATE ( OR ( ROLLBACK / ABORT / REPLACE / FAIL / IGNORE ) )? qualified_table_name )
    ( SET ( ( column_name equal expr ) comma )+ ( WHERE expr )? ) )

update_stmt_limited =
  ( ( UPDATE ( OR ( ROLLBACK / ABORT / REPLACE / FAIL / IGNORE ) )? qualified_table_name )
    ( SET ( ( column_name equal expr ) comma )+ ( WHERE expr )? )
    ( ( ( ORDER BY ( ordering_term comma )+ )? ( LIMIT expr ( ( OFFSET / comma ) expr )? ) ) )? )

qualified_table_name =
  ( ( database_name dot )? table_name ( ( INDEXED BY index_name ) / ( NOT INDEXED ) )? )

vacuum_stmt =
VACUUM

comment_syntax =
  ( ( minusminus ( anything_except_newline )+ ( newline / end_of_input ) )
  / ( comment_beg ( anything_except_comment_end )+ ( comment_end / end_of_input ) ) )

dot = '.'
comma = ','
semicolon = ';'
minusminus = '--'
minus = '-'
plus = '+'
lparen = '('
rparen = ')'
star = '*'
newline = '\n'
anything_except_newline = [^\n]*
comment_beg = '/*'
comment_end = '*/'
anything_except_comment_end = .* & '*/'
string_literal = '"' (escape_char / [^"])* '"'
escape_char = '\\' .
nil = ''

whitespace =
  [ \t\n\r]*
whitespace1 =
  [ \t\n\r]+

unary_operator =
  ( whitespace
    ( '-' / '+' / '~' / 'NOT') )

binary_operator =
  ( whitespace
    ('||'
     / '*' / '/' / '%'
     / '+' / '-'
     / '<<' / '>>' / '&' / '|'
     / '<=' / '>='
     / '<' / '>'
     / '=' / '==' / '!=' / '<>'
     / 'IS' / 'IS NOT' / 'IN' / 'LIKE' / 'GLOB' / 'MATCH' / 'REGEXP'
     / 'AND'
     / 'OR') )

digit = [0-9]
decimal_point = dot
equal = '='

name = [A-Za-z0-9_]+
database_name = name
table_name = name
table_alias = name
table_or_index_name = name
new_table_name = name
index_name = name
column_name = name
column_alias = name
foreign_table = name
savepoint_name = name
collation_name = name
trigger_name = name
view_name = name
module_name = name
module_argument = name
bind_parameter = name
function_name = name
pragma_name = name

error_message = string_literal

CURRENT_TIME = 'now'
CURRENT_DATE = 'now'
CURRENT_TIMESTAMP = 'now'

blob_literal = string_literal

end_of_input = ''

ABORT = whitespace1 "ABORT"
ACTION = whitespace1 "ACTION"
ADD = whitespace1 "ADD"
AFTER = whitespace1 "AFTER"
ALL = whitespace1 "ALL"
ALTER = whitespace1 "ALTER"
ANALYZE = whitespace1 "ANALYZE"
AND = whitespace1 "AND"
AS = whitespace1 "AS"
ASC = whitespace1 "ASC"
ATTACH = whitespace1 "ATTACH"
AUTOINCREMENT = whitespace1 "AUTOINCREMENT"
BEFORE = whitespace1 "BEFORE"
BEGIN = whitespace1 "BEGIN"
BETWEEN = whitespace1 "BETWEEN"
BY = whitespace1 "BY"
CASCADE = whitespace1 "CASCADE"
CASE = whitespace1 "CASE"
CAST = whitespace1 "CAST"
CHECK = whitespace1 "CHECK"
COLLATE = whitespace1 "COLLATE"
COLUMN = whitespace1 "COLUMN"
COMMIT = whitespace1 "COMMIT"
CONFLICT = whitespace1 "CONFLICT"
CONSTRAINT = whitespace1 "CONSTRAINT"
CREATE =
  whitespace "CREATE"
CROSS = whitespace1 "CROSS"
DATABASE = whitespace1 "DATABASE"
DEFAULT = whitespace1 "DEFAULT"
DEFERRABLE = whitespace1 "DEFERRABLE"
DEFERRED = whitespace1 "DEFERRED"
DELETE =
  whitespace "DELETE"
DESC = whitespace1 "DESC"
DETACH = whitespace1 "DETACH"
DISTINCT = whitespace1 "DISTINCT"
DROP = whitespace1 "DROP"
E =
  "E"
EACH = whitespace1 "EACH"
ELSE = whitespace1 "ELSE"
END = whitespace1 "END"
ESCAPE = whitespace1 "ESCAPE"
EXCEPT = whitespace1 "EXCEPT"
EXCLUSIVE = whitespace1 "EXCLUSIVE"
EXISTS = whitespace1 "EXISTS"
EXPLAIN =
  whitespace "EXPLAIN"
FAIL = whitespace1 "FAIL"
FOR = whitespace1 "FOR"
FOREIGN = whitespace1 "FOREIGN"
FROM = whitespace1 "FROM"
GLOB = whitespace1 "GLOB"
GROUP = whitespace1 "GROUP"
HAVING = whitespace1 "HAVING"
IF = whitespace1 "IF"
IGNORE = whitespace1 "IGNORE"
IMMEDIATE = whitespace1 "IMMEDIATE"
IN = whitespace1 "IN"
INDEX = whitespace1 "INDEX"
INDEXED = whitespace1 "INDEXED"
INITIALLY = whitespace1 "INITIALLY"
INNER = whitespace1 "INNER"
INSERT =
  whitespace "INSERT"
INSTEAD = whitespace1 "INSTEAD"
INTERSECT = whitespace1 "INTERSECT"
INTO = whitespace1 "INTO"
IS = whitespace1 "IS"
ISNULL = whitespace1 "ISNULL"
JOIN = whitespace1 "JOIN"
KEY = whitespace1 "KEY"
LEFT = whitespace1 "LEFT"
LIKE = whitespace1 "LIKE"
LIMIT = whitespace1 "LIMIT"
MATCH = whitespace1 "MATCH"
NATURAL = whitespace1 "NATURAL"
NO = whitespace1 "NO"
NOT = whitespace1 "NOT"
NOTNULL = whitespace1 "NOTNULL"
NULL = whitespace1 "NULL"
OF = whitespace1 "OF"
OFFSET = whitespace1 "OFFSET"
ON = whitespace1 "ON"
OR = whitespace1 "OR"
ORDER = whitespace1 "ORDER"
OUTER = whitespace1 "OUTER"
PLAN = whitespace1 "PLAN"
PRAGMA = whitespace1 "PRAGMA"
PRIMARY = whitespace1 "PRIMARY"
QUERY = whitespace1 "QUERY"
RAISE = whitespace1 "RAISE"
REFERENCES = whitespace1 "REFERENCES"
REGEXP = whitespace1 "REGEXP"
REINDEX = whitespace1 "REINDEX"
RELEASE = whitespace1 "RELEASE"
RENAME = whitespace1 "RENAME"
REPLACE =
  whitespace "REPLACE"
RESTRICT = whitespace1 "RESTRICT"
ROLLBACK = whitespace1 "ROLLBACK"
ROW = whitespace1 "ROW"
SAVEPOINT = whitespace1 "SAVEPOINT"
SELECT =
  whitespace "SELECT"
SET = whitespace1 "SET"
TABLE = whitespace1 "TABLE"
TEMP = whitespace1 "TEMP"
TEMPORARY = whitespace1 "TEMPORARY"
THEN = whitespace1 "THEN"
TO = whitespace1 "TO"
TRANSACTION = whitespace1 "TRANSACTION"
TRIGGER = whitespace1 "TRIGGER"
UNION = whitespace1 "UNION"
UNIQUE = whitespace1 "UNIQUE"
UPDATE =
  whitespace "UPDATE"
USING = whitespace1 "USING"
VACUUM = whitespace1 "VACUUM"
VALUES = whitespace1 "VALUES"
VIEW = whitespace1 "VIEW"
VIRTUAL = whitespace1 "VIRTUAL"
WHEN = whitespace1 "WHEN"
WHERE = whitespace1 "WHERE"
