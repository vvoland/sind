group "default" {
  targets = ["image"]
}

target "image" {
  output     = ["type=image,name=vlnd/steam,compression=uncompressed"]
}

target "dist" {
  output     = ["type=registry,name=vlnd/steam,force-compression=true,push=true"]
}
