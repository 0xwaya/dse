/* Moralis init code */
const serverUrl = "https://ltogrccktp5o.usemoralis.com:2053/server";
const appId = "3WZlDdHJr5Pfz7WuDlmFbvrNl4JuSPwL2U09bUb6";
Moralis.start({ serverUrl, appId });


async function login() {
  let user = Moralis.User.current();
  if (!user) {
   try {
      user = await Moralis.authenticate({ signingMessage: "WayaLabs TestNet Signature" })
      console.log(user)
      console.log(user.get('ethAddress'))
   } catch(error) {
     console.log(error)
   }
  }
}

async function logOut() {
  await Moralis.User.logOut();
  console.log("logged out");
}

document.getElementById("btn-login").onclick = login;
document.getElementById("btn-logout").onclick = logOut;