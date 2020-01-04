module CameraModels

using StaticArrays, CoordinateTransformations

export Ray, CameraModel, pixel2ray, point2pixel, Pinhole

const PixelCoordinate = SVector{2, Float64}
const Point3 = SVector{3, Float64}
const Vector3 = Point3

abstract type CameraModel end

struct Ray
    origin::Point3
    direction::Vector3
end

"""
    pixel2ray(cameramodel::CameraModel, pixelcoordinate::$(PixelCoordinate))

Returns the ray in space (origin + direction) corresponding to this `pixelcoordinate`.
"""
function pixel2ray end

"""
    point2pixel(camera::CameraModel, pointincamera::$(Point3))

Returns the pixel location onto which the 3D coordinate `pointincamera` is projected.
"""
function point2pixel end



struct Pinhole <: CameraModel
    prinicipalpoint::Tuple{Float64, Float64} # in pixels
    focallength::Tuple{Float64, Float64} # in pixels
    skewcoefficient::Float64
end

"""
    point2pixel(m::PinHole)
Return a transformation that converts real-world coordinates
to camera coordinates. This currently ignores any tangential 
distortion between the lens and the image plane.
"""
point2pixel(m::Pinhole) = cameramap(m.intrinsic.focallength, m.intrinsic.prinicipalpoint) ∘ inv(AffineMap(RotXYZ(m.extrinsic.direction...), m.extrinsic.location))

# TODO: Also implement pixel2ray for PinHole

# MORE IDEAS:
# - Something like CoordinateTransformations' transform_deriv / transform_deriv_params, will be useful for estimators
# - Could a camera model BE a CoordinateTransformations.Transform ?
# - In doubt if pixel2ray/point2pixel should return a transform or DO the transform... The former will lead to ugly code, I find...
# - I don't like the Ray struct... For many users, all rays will have zero origin anyways. I'm in accurate underwater and 360 business,
#   where the shift of the origin matters. I'll be extending this later with some very exotic camera models, which will need something
#   like this. Needs some more thought... 
#   --> Maybe a pixel2rayorigin, which defaults to calling to the "simple" pixel2ray and adding a default zero origin. When you do the
#       accurate stuff, you would call pixel2rayorigin rather then pixel2ray. And only the funky models would have to implement it.    

end # module
