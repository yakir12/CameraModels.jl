module CameraModels

using StaticArrays, CoordinateTransformations

export Intrinsic, Extrinsic, Pinhole, CameraModel, real2pixel

abstract type CameraModel end

struct Intrinsic
    prinicipalpoint::Tuple{Float64, Float64} # in pixels
    focallength::Tuple{Float64, Float64} # in pixels
    skewcoefficient::Float64
end

struct Extrinsic
    location::SVector{3, Float64}
    direction::SVector{3, Float64}
end

struct Pinhole <: CameraModel
    intrinsic::Intrinsic
    extrinsic::Extrinsic
end

"""
    real2pixel(m::PinHole)
Return a transformation that converts real-world coordinates
to camera coordinates. This currently ignores any tangential 
distortion between the lens and the image plane.
"""
real2pixel(m::Pinhole) = cameramap(m.intrinsic.focallength, m.intrinsic.prinicipalpoint) ∘ inv(AffineMap(RotXYZ(m.extrinsic.direction...), m.extrinsic.location))

end # module
