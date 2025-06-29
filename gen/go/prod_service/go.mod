module github.com/HollyEllmo/my_proto_repo/gen/go/prod_service

go 1.24.2

require (
	github.com/HollyEllmo/my-proto-repo/gen/go/filter v0.0.0
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.26.3
	google.golang.org/genproto/googleapis/api v0.0.0-20250603155806-513f23925822
	google.golang.org/grpc v1.73.0
	google.golang.org/protobuf v1.36.6
)

require (
	golang.org/x/net v0.38.0 // indirect
	golang.org/x/sys v0.31.0 // indirect
	golang.org/x/text v0.23.0 // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20250528174236-200df99c418a // indirect
)

replace github.com/HollyEllmo/my-proto-repo/gen/go/filter => ../filter
