# frozen_string_literal: true

class CreateCasedAuditEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :cased_audit_events do |t|
      t.string :audit_event_id, null: false, limit: 32
      t.text :audit_event, null: false
      t.datetime :created_at, null: false, precision: 6
      t.index :audit_event_id, unique: true
    end
  end
end
