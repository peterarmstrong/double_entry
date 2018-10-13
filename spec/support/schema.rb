ActiveRecord::Schema.define do
  self.verbose = false

  create_table "double_entry_account_balances", :force => true do |t|
    t.string     "account", :limit => 31, :null => false
    t.string     "scope",   :limit => 23
    t.integer    "balance",               :null => false
    t.timestamps                          :null => false
  end

  add_index "double_entry_account_balances", ["account"],          :name => "index_account_balances_on_account"
  add_index "double_entry_account_balances", ["scope", "account"], :name => "index_account_balances_on_scope_and_account", :unique => true

  create_table "double_entry_lines", :force => true do |t|
    t.string     "account",         :limit => 31, :null => false
    t.string     "scope",           :limit => 23
    t.string     "code",            :limit => 47, :null => false
    t.integer    "amount",                        :null => false
    t.integer    "balance",                       :null => false
    t.integer    "partner_id"
    t.string     "partner_account", :limit => 31, :null => false
    t.string     "partner_scope",   :limit => 23
    t.integer    "detail_id"
    t.string     "detail_type"
    t.timestamps                                  :null => false
  end

  add_index "double_entry_lines", ["account", "code", "created_at", "partner_account"],  :name => "lines_account_code_created_at_partner_account_idx"
  add_index "double_entry_lines", ["account", "created_at"],                             :name => "lines_account_created_at_idx"
  add_index "double_entry_lines", ["scope", "account", "created_at"],                    :name => "lines_scope_account_created_at_idx"
  add_index "double_entry_lines", ["scope", "account", "id"],                            :name => "lines_scope_account_id_idx"

  create_table "double_entry_line_checks", :force => true do |t|
    t.integer    "last_line_id", :null => false
    t.boolean    "errors_found", :null => false
    t.text       "log"
    t.timestamps                 :null => false
  end

  add_index "double_entry_line_checks", ["created_at", "last_line_id"], :name => "line_checks_created_at_last_line_id_idx"

  create_table "double_entry_line_metadata", :force => true do |t|
    t.integer    "line_id",               :null => false
    t.string     "key",     :limit => 48, :null => false
    t.string     "value",   :limit => 64, :null => false
    t.timestamps                          :null => false
  end

  add_index "double_entry_line_metadata", ["line_id", "key", "value"], :name => "lines_meta_line_id_key_value_idx"

  # test table only
  create_table "users", :force => true do |t|
    t.string     "username", :null => false
    t.timestamps             :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true
end
