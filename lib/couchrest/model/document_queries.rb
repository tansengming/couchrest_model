module CouchRest
  module Model
    module DocumentQueries
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
      module ClassMethods
        
        # Load all documents that have the model_type_key's field equal to the
        # name of the current class. Take the standard set of
        # CouchRest::Database#view options.
        def all(opts = {}, &block)
          view(:all, opts, &block)
        end
        
        # Returns the number of documents that have the model_type_key's field
        # equal to the name of the current class. Takes the standard set of 
        # CouchRest::Database#view options
        def count(opts = {}, &block)
          all({:raw => true, :limit => 0}.merge(opts), &block)['total_rows']
        end
        
        # Load the first document that have the model_type_key's field equal to
        # the name of the current class.
        #
        # ==== Returns
        # Object:: The first object instance available
        # or
        # Nil:: if no instances available
        #
        # ==== Parameters
        # opts<Hash>::
        # View options, see <tt>CouchRest::Database#view</tt> options for more info.
        def first(opts = {})
          first_instance = self.all(opts.merge!(:limit => 1))
          first_instance.empty? ? nil : first_instance.first
        end
        
        # Load the last document that have the model_type_key's field equal to
        # the name of the current class.
        # It's similar to method first, just adds :descending => true
        #
        # ==== Returns
        # Object:: The last object instance available
        # or
        # Nil:: if no instances available
        #
        # ==== Parameters
        # opts<Hash>::
        # View options, see <tt>CouchRest::Database#view</tt> options for more info.
        def last(opts = {})
          first(opts.merge!(:descending => true))
        end
        
        # Load a document from the database by id
        # No exceptions will be raised if the document isn't found
        #
        # ==== Returns
        # Object:: if the document was found
        # or
        # Nil::
        # 
        # === Parameters
        # id<String, Integer>:: Document ID
        # db<Database>:: optional option to pass a custom database to use
        def get(id, db = database)
          begin
            get!(id, db)
          rescue
            nil
          end
        end
        alias :find :get
        
        # Load a document from the database by id
        # An exception will be raised if the document isn't found
        #
        # ==== Returns
        # Object:: if the document was found
        # or
        # Exception
        # 
        # === Parameters
        # id<String, Integer>:: Document ID
        # db<Database>:: optional option to pass a custom database to use
        def get!(id, db = database)
          raise "Missing or empty document ID" if id.to_s.empty?
          doc = db.get id
          create_from_database(doc)
        end
        alias :find! :get!
        
      end
      
    end
  end
end
