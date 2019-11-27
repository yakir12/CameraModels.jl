using CameraModels
using Test

@testset "real to camera" begin
    intrinsic = Intrinsic((0., 0.), (1., 0), 0.0)
    extrinsic = Extrinsic([0., 0, 0], [1., 0, 0])
    m = Pinhole(intrinsic, extrinsic)
    f = real2pixel(m)
    @test f([0,0,1]) == [0, 0]
end
