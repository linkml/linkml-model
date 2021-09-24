

CREATE TABLE alt_description (
	source TEXT NOT NULL, 
	description TEXT NOT NULL, 
	PRIMARY KEY (source, description)
);

CREATE TABLE annotation (
	tag TEXT NOT NULL, 
	value TEXT NOT NULL, 
	extensions TEXT, 
	annotations TEXT, 
	PRIMARY KEY (tag, value, extensions, annotations)
);

CREATE TABLE class_definition (
	name TEXT NOT NULL, 
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	abstract BOOLEAN, 
	mixin BOOLEAN, 
	created_by TEXT, 
	created_on DATETIME, 
	last_updated_on DATETIME, 
	modified_by TEXT, 
	status TEXT, 
	string_serialization TEXT, 
	slots TEXT, 
	slot_usage TEXT, 
	attributes TEXT, 
	class_uri TEXT, 
	subclass_of TEXT, 
	union_of TEXT, 
	defining_slots TEXT, 
	tree_root BOOLEAN, 
	is_a TEXT, 
	mixins TEXT, 
	apply_to TEXT, 
	PRIMARY KEY (name), 
	FOREIGN KEY(is_a) REFERENCES class_definition (name)
);

CREATE TABLE example (
	value TEXT, 
	description TEXT, 
	PRIMARY KEY (value, description)
);

CREATE TABLE extension (
	tag TEXT NOT NULL, 
	value TEXT NOT NULL, 
	extensions TEXT, 
	PRIMARY KEY (tag, value, extensions)
);

CREATE TABLE local_name (
	local_name_source TEXT NOT NULL, 
	local_name_value TEXT NOT NULL, 
	PRIMARY KEY (local_name_source, local_name_value)
);

CREATE TABLE permissible_value (
	text TEXT NOT NULL, 
	description TEXT, 
	meaning TEXT, 
	is_a TEXT, 
	mixins TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	PRIMARY KEY (text), 
	FOREIGN KEY(is_a) REFERENCES permissible_value (text)
);

CREATE TABLE subset_definition (
	name TEXT NOT NULL, 
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	PRIMARY KEY (name)
);

CREATE TABLE type_definition (
	name TEXT NOT NULL, 
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	typeof TEXT, 
	base TEXT, 
	uri TEXT, 
	repr TEXT, 
	pattern TEXT, 
	PRIMARY KEY (name), 
	FOREIGN KEY(typeof) REFERENCES type_definition (name)
);

CREATE TABLE unique_key (
	unique_key_slots TEXT NOT NULL, 
	extensions TEXT, 
	annotations TEXT, 
	PRIMARY KEY (unique_key_slots, extensions, annotations)
);

CREATE TABLE schema_definition (
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	id TEXT NOT NULL, 
	version TEXT, 
	license TEXT, 
	default_prefix TEXT, 
	default_range TEXT, 
	subsets TEXT, 
	types TEXT, 
	slots TEXT, 
	classes TEXT, 
	metamodel_version TEXT, 
	source_file TEXT, 
	source_file_date DATETIME, 
	source_file_size INTEGER, 
	generation_date DATETIME, 
	name TEXT NOT NULL, 
	PRIMARY KEY (name), 
	FOREIGN KEY(default_range) REFERENCES type_definition (name)
);

CREATE TABLE slot_definition (
	name TEXT NOT NULL, 
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	abstract BOOLEAN, 
	mixin BOOLEAN, 
	created_by TEXT, 
	created_on DATETIME, 
	last_updated_on DATETIME, 
	modified_by TEXT, 
	status TEXT, 
	string_serialization TEXT, 
	singular_name TEXT, 
	domain TEXT, 
	range TEXT, 
	slot_uri TEXT, 
	multivalued BOOLEAN, 
	inherited BOOLEAN, 
	readonly TEXT, 
	ifabsent TEXT, 
	required BOOLEAN, 
	recommended BOOLEAN, 
	inlined BOOLEAN, 
	inlined_as_list BOOLEAN, 
	"key" BOOLEAN, 
	identifier BOOLEAN, 
	designates_type BOOLEAN, 
	alias TEXT, 
	owner TEXT, 
	domain_of TEXT, 
	subproperty_of TEXT, 
	symmetric BOOLEAN, 
	inverse TEXT, 
	is_class_field BOOLEAN, 
	role TEXT, 
	is_usage_slot BOOLEAN, 
	usage_slot_name TEXT, 
	minimum_value INTEGER, 
	maximum_value INTEGER, 
	pattern TEXT, 
	is_a TEXT, 
	mixins TEXT, 
	apply_to TEXT, 
	PRIMARY KEY (name), 
	FOREIGN KEY(domain) REFERENCES class_definition (name), 
	FOREIGN KEY(subproperty_of) REFERENCES slot_definition (name), 
	FOREIGN KEY(inverse) REFERENCES slot_definition (name), 
	FOREIGN KEY(is_a) REFERENCES slot_definition (name)
);

CREATE TABLE class_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE class_definition_values_from (
	backref_id TEXT, 
	values_from TEXT, 
	PRIMARY KEY (backref_id, values_from), 
	FOREIGN KEY(backref_id) REFERENCES class_definition (name)
);

CREATE TABLE permissible_value_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES permissible_value (text)
);

CREATE TABLE permissible_value_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES permissible_value (text)
);

CREATE TABLE permissible_value_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES permissible_value (text)
);

CREATE TABLE permissible_value_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES permissible_value (text)
);

CREATE TABLE subset_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE subset_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES subset_definition (name)
);

CREATE TABLE type_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE type_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES type_definition (name)
);

CREATE TABLE enum_definition (
	name TEXT NOT NULL, 
	title TEXT, 
	definition_uri TEXT, 
	local_names TEXT, 
	extensions TEXT, 
	annotations TEXT, 
	description TEXT, 
	alt_descriptions TEXT, 
	deprecated TEXT, 
	examples TEXT, 
	in_subset TEXT, 
	from_schema TEXT, 
	imported_from TEXT, 
	deprecated_element_has_exact_replacement TEXT, 
	deprecated_element_has_possible_replacement TEXT, 
	code_set TEXT, 
	code_set_tag TEXT, 
	code_set_version TEXT, 
	pv_formula VARCHAR(11), 
	permissible_values TEXT, 
	schema_definition_name TEXT, 
	PRIMARY KEY (name), 
	FOREIGN KEY(schema_definition_name) REFERENCES schema_definition (name)
);

CREATE TABLE prefix (
	prefix_prefix TEXT NOT NULL, 
	prefix_reference TEXT NOT NULL, 
	schema_definition_name TEXT, 
	PRIMARY KEY (prefix_prefix, prefix_reference, schema_definition_name), 
	FOREIGN KEY(schema_definition_name) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_imports (
	backref_id TEXT, 
	imports TEXT, 
	PRIMARY KEY (backref_id, imports), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_emit_prefixes (
	backref_id TEXT, 
	emit_prefixes TEXT, 
	PRIMARY KEY (backref_id, emit_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE schema_definition_default_curi_maps (
	backref_id TEXT, 
	default_curi_maps TEXT, 
	PRIMARY KEY (backref_id, default_curi_maps), 
	FOREIGN KEY(backref_id) REFERENCES schema_definition (name)
);

CREATE TABLE slot_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE slot_definition_values_from (
	backref_id TEXT, 
	values_from TEXT, 
	PRIMARY KEY (backref_id, values_from), 
	FOREIGN KEY(backref_id) REFERENCES slot_definition (name)
);

CREATE TABLE enum_definition_id_prefixes (
	backref_id TEXT, 
	id_prefixes TEXT, 
	PRIMARY KEY (backref_id, id_prefixes), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_aliases (
	backref_id TEXT, 
	aliases TEXT, 
	PRIMARY KEY (backref_id, aliases), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_mappings (
	backref_id TEXT, 
	mappings TEXT, 
	PRIMARY KEY (backref_id, mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_exact_mappings (
	backref_id TEXT, 
	exact_mappings TEXT, 
	PRIMARY KEY (backref_id, exact_mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_close_mappings (
	backref_id TEXT, 
	close_mappings TEXT, 
	PRIMARY KEY (backref_id, close_mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_related_mappings (
	backref_id TEXT, 
	related_mappings TEXT, 
	PRIMARY KEY (backref_id, related_mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_narrow_mappings (
	backref_id TEXT, 
	narrow_mappings TEXT, 
	PRIMARY KEY (backref_id, narrow_mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_broad_mappings (
	backref_id TEXT, 
	broad_mappings TEXT, 
	PRIMARY KEY (backref_id, broad_mappings), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_todos (
	backref_id TEXT, 
	todos TEXT, 
	PRIMARY KEY (backref_id, todos), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_notes (
	backref_id TEXT, 
	notes TEXT, 
	PRIMARY KEY (backref_id, notes), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_comments (
	backref_id TEXT, 
	comments TEXT, 
	PRIMARY KEY (backref_id, comments), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

CREATE TABLE enum_definition_see_also (
	backref_id TEXT, 
	see_also TEXT, 
	PRIMARY KEY (backref_id, see_also), 
	FOREIGN KEY(backref_id) REFERENCES enum_definition (name)
);

