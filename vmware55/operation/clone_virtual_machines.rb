@log.trace("Started execution 'flint-vmware:vc55:clone_vm.rb' flintbit...") # execution Started
begin

    # Flintbit input parametes
    @connector_name = @input.get("connector_name")                # "vmware"
    @action = @input.get('action')
    @username = @input.get('username')
    @password=@input.get('password')
    @url=@input.get('url')
    @datacenter=@input.get('datacenter-name')
    @vmpath=@input.get('virtualMachine-path')
    @clonename=@input.get('clone-name')

    #Optional
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    # calling vmware connector
    response = @call.connector(@connector_name)
                    .set('action',@action)
		                .set('url',@url)
		                .set('username',@username)
		                .set('password',@password)
		                .set('datacenter-name',@datacenter)
		                .set('virtualMachine-path',@vmpath)
		                .set('clone-name',@clonename)
                    .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message


      if response_exitcode==0
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set("result::", "success")

      else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
      end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'flint-vmware:vc55:clone_vm.rb' flintbit...")
