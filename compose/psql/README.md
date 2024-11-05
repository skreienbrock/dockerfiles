# postgres / pgadmin compose file
please create the volume sqldata before using.
 podman volume create sqldata

data itself can be found using
 podman inspect volume sqldata

    user@cyan:~/git/scripts/compose/postgresql$ podman inspect volume sqldata
    [
        {
            "Name": "sqldata",
            "Driver": "local",
            "Mountpoint": "/home/user/.local/share/containers/storage/volumes/sqldata/_data",
            "CreatedAt": "2024-11-04T20:40:31.015816402+01:00",
            "Labels": {},
            "Scope": "local",
            "Options": {},
            "UID": 1001
       }
    ]

