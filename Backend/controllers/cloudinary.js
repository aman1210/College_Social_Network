const cloudinary = require("cloudinary").v2;
const fs = require("fs");

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_KEY,
  api_secret: process.env.CLOUDINARY_SECERT,
  secure: true,
});

exports.uploads = async (fileLoc) => {
  var mainFileLoc = "main";
  var filePathOnCloudinary = mainFileLoc + "/" + fileLoc;
  return cloudinary.uploader
    .upload(fileLoc, { public_id: filePathOnCloudinary })
    .then((result) => {
      fs.unlinkSync(fileLoc);

      return {
        message: "Success",
        url: result.url,
      };
    })
    .catch((error) => {
      fs.unlinkSync(fileLoc);
      return { message: "Fail", error: error };
    });
};
