
export Pinhole

struct Pinhole{C,R} <: CameraModel where C where Return
    
    Pinhole(pixelwidth::Int, pixelheight::Int, prinicipalpoint::PixelCoordinate, focallength::Vector2) = new{pixelwidth, pixelheight}(prinicipalpoint, focallength)

    prinicipalpoint::PixelCoordinate # in pixels
    focallength::Vector2 # in pixels
end

"""
    point2pixel(model::Pinhole, pointincamera::$(Point3))

Return a transformation that converts real-world coordinates
to camera coordinates. This currently ignores any tangential 
distortion between the lens and the image plane.
"""
function point2pixel(model::Pinhole, pointincamera::Point3)
    column = model.prinicipalpoint[1] + model.focallength[1] * pointincamera[1] / pointincamera[2]
    row = model.prinicipalpoint[2] - model.focallength[2] * pointincamera[3] / pointincamera[2]
    return PixelCoordinate(column, row)
end

"""
    pixel2ray(model::Pinhole, pixelcoordinate::$(PixelCoordinate))

Return a transformation that converts real-world coordinates
to camera coordinates. This currently ignores any tangential 
distortion between the lens and the image plane.
"""
function pixel2ray(model::Pinhole, pixelcoordinate::PixelCoordinate)
    x = (pixelcoordinate[1] - model.prinicipalpoint[1]) / model.focallength[1]
    z = -(pixelcoordinate[2] - model.prinicipalpoint[2]) / model.focallength[2]
    return Vector3(x, 1, z)
end

lookdirection(cameramodel::Pinhole) = SVector{3}(0,1,0)
updirection(cameramodel::Pinhole) = SVector{3}(0,0,1)

columns(cameramodel::Pinhole{NColumns, NRows}) where NColumns where NRows = NColumns 
rows(cameramodel::Pinhole{NColumns, NRows}) where NColumns where NRows = NRows 
