Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  def create_consul_host(config, hostname, ip, initJson)
    config.vm.define hostname do |host|

		host.vm.hostname = hostname
		host.vm.provision "shell", path: "provision.sh"

		host.vm.network "private_network", ip: ip
		host.vm.provision "shell", inline: "echo '#{initJson}' > /etc/systemd/system/consul.d/init.json"
		host.vm.provision "shell", inline: "service consul start"
    end
  end

  def create_consul_win_host(config, hostname, ip, initJson)
    config.vm.define hostname do |host|
      host.vm.box = "mwrock/Windows2016"
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: ip

      host.vm.provision "shell", path: "provision.ps1"
      host.vm.provision "shell", inline: "Set-Content -Value '#{initJson}' -Path C:\\Consul\\init.json"
      host.vm.provision "shell", inline: "Start-Process consul.exe -WorkingDirectory C:\\Consul -ArgumentList 'agent', '-config-dir=C:\\Consul'"
    end
  end

  # Create server.
  serverIP = "192.168.10.10"
  serverInit = %(
	{
		"server": true,
		"ui": true,
		"advertise_addr": "#{serverIP}",
		"client_addr": "#{serverIP}",
		"data_dir": "/tmp/consul",
		"bootstrap_expect": 1
	}
  )

  create_consul_host config, "consul-server", serverIP, serverInit

  # Create Linux agents.
  for host_number in 1..2
    hostname="host-#{host_number}"
    clientIP="192.168.10.1#{host_number}"

    clientInit = %(
      {
        "advertise_addr": "#{clientIP}",
        "retry_join": ["#{serverIP}"],
        "data_dir": "/tmp/consul"
      }
    )

    create_consul_host config, hostname, clientIP, clientInit
  end

  # Create windows agent
  winClientIP = "192.168.10.13"
  winClientInit = %(
    {
      "advertise_addr": "#{winClientIP}",
      "retry_join": ["#{serverIP}"],
      "data_dir": "C:\\\\Consul\\\\data"
    }
  )

  create_consul_win_host config, "host-win", winClientIP, winClientInit
end
