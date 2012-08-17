Puppet::Type.newtype(:serveradmin) do
	@doc = "Modify settings of the first element matching the Path expression in OS X server config."


	newparam(:name) do
		desc <<-EOS
			The key shown in the serveradmin cli.
			For a single entry, everything before the equals symbol.
			To change an array use the special key _array_id followed
			by the value of the id tag (eg. web:Modules:_array_id:dav_module).
		EOS
		isnamevar
	end

	newparam(:settings) do
		desc <<-EOS
			Things to change.
			Supplying single values will apply for single entry.
			To change an array this is a hash of keys and values, for 'ipfilter:standardServices:_array_id:Puppet Master'.

            { readOnly => yes, protocol => "tcp", name => "", dest-port => "8140" }

		EOS
		defaultto ""
	end

	newproperty(:ensure) do
		desc <<-EOS
			The expected state of the resource.
			Defaults to keeping entry and values insync.
			To remove entry change to empty.
		EOS
		defaultto :insync
		newvalue(:insync) do
			if @resource.provider and @resource.provider.respond_to?(:write)
				@resource.provider.write
			else
				@resource.write
			end
			nil # return nil so the event is autogenerated
		end
		newvalue(:empty) do
			if @resource.provider and @resource.provider.respond_to?(:delete)
				@resource.provider.delete
			else
				@resource.delete
			end
			nil # return nil so the event is autogenerated
		end
		def retrieve
			if @resource.provider and @resource.provider.respond_to?(:check)
				return @resource.provider.check
			else
				return @resource.check
			end
			nil
		end
	end

end
