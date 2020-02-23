module ApplicationHelper
    def createLog(value)
        app_id = doorkeeper_token.application_id rescue nil;
        if !app_id.nil?
            value["app_id"] = app_id
        end
        value["request"] = request.remote_ip.to_s
        Log.new(item: value.to_json).save
    end

    def valid_json?(json)
        JSON.parse(json)
        return true
      rescue JSON::ParserError => e
        return false
    end

    def container_format
        @info = Overlay.find_by_name("general")
        if @info.nil?
            return nil
        end
        return JSON.parse(@info.body)["syntax"]
    end

    def container_usage_policy
        if Semantic.count > 0
            init = RDF::Repository.new()
            init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
            uc = nil
            init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "UsagePolicy" ? uc = g : nil }
            if uc.nil?
                nil
            else
                uc.dump(:trig).to_s
            end
        else 
            nil
        end
    end

    def data_constraints
        if Semantic.count > 0
            init = RDF::Repository.new()
            init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
            dc = nil
            init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "DataConstraint" ? dc = g : nil }
            if dc.nil?
                nil
            else
                dc.dump(:trig).to_s.strip.split("\n")[1..-2].join("\n")
            end
        else 
            nil
        end
    end

    def payment_billing_service_url
        bc = nil
        image_constraints = RDF::Repository.load("./config/image-constraints.trig", format: :trig)
        image_constraints.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "ImageConfiguration" ? bc = g : nil }
        billing_service_url = RDF::Query.execute(bc) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "billingService"), :value] }.first.value.to_s rescue ""
        if billing_service_url == ""
            billing_service_url = "http://srv-billing:3000"
        end
        billing_service_url
    end


    def payment_info_text
        if Semantic.count > 0 and Semantic.first.validation.to_s != ""
            # check data format in configuration
            init = RDF::Repository.new()
            init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
            ic = nil
            init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "BaseConfiguration" ? ic = g : nil }
            RDF::Query.execute(ic) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasPaymentInfo"), :value] }.first.value.to_s rescue nil
        else
            nil
        end
    end

    def payment_seller_email
        if Semantic.count > 0 and Semantic.first.validation.to_s != ""
            # check data format in configuration
            init = RDF::Repository.new()
            init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
            ic = nil
            init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "BaseConfiguration" ? ic = g : nil }
            RDF::Query.execute(ic) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasSellerEmail"), :value] }.first.value.to_s rescue nil
        else
            nil
        end
    end

    def payment_seller_pubkey_id
        if Semantic.count > 0 and Semantic.first.validation.to_s != ""
            # check data format in configuration
            init = RDF::Repository.new()
            init << RDF::Reader.for(:trig).new(Semantic.first.validation.to_s)
            ic = nil
            init.each_graph{ |g| g.graph_name == SEMCON_ONTOLOGY + "BaseConfiguration" ? ic = g : nil }
            RDF::Query.execute(ic) { pattern [:subject, RDF::URI.new(SEMCON_ONTOLOGY + "hasSellerPubkeyID"), :value] }.first.value.to_s rescue nil
        else
            nil
        end
    end

    def suppress_output
      begin
        original_stderr = $stderr.clone
        original_stdout = $stdout.clone
        $stderr.reopen(File.new('/dev/null', 'w'))
        $stdout.reopen(File.new('/dev/null', 'w'))
        retval = yield
      rescue Exception => e
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
        raise e
      ensure
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
      end
      retval
    end    
end
