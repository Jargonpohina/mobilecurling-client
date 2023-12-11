'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f38455399ecec2e2de3f7e20da5fbe07",
"assets/AssetManifest.bin.json": "7925e79b618258760678f12c962e7965",
"assets/AssetManifest.json": "7d521885688a05d6390175b3b0489fef",
"assets/assets/4539d0bd154c187e375608321789169d.ico.zip": "314b161e8ee45485517a7776f98a6c1a",
"assets/assets/hajaprojekti.drawio.png": "55624c19871887425207bc623d573061",
"assets/assets/logo.png": "7d92d5a8f289f59a6c9605909081cfa7",
"assets/assets/stone_one.png": "085149a3c7d21d737e60d2994002f855",
"assets/assets/stone_two.png": "8457980faae85ade7d97ac951906e3e3",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "fd0f55996608d457a89216a64322b57e",
"assets/NOTICES": "ae66541eb3fdc3f1f61f124cecf2ec79",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "64edb91684bdb3b879812ba2e48dd487",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "f87e541501c96012c252942b6b75d1ea",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "4124c42a73efa7eb886d3400a1ed7a06",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "6cbcd3af6fe764bdd1d00be9a6402378",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/android-icon-144x144.png": "954c712f4fa226797e83972093092ae5",
"icons/android-icon-192x192.png": "d172380e57c69170e3dd784733c5455c",
"icons/android-icon-36x36.png": "f908c57a9de73140190d4e074733cb10",
"icons/android-icon-48x48.png": "b89a17b16b46e72dd0dd500b8b596b83",
"icons/android-icon-72x72.png": "061893fc6c6fe9187e493d7cf3e339e5",
"icons/android-icon-96x96.png": "c94b063a01cd7b97bbb7b88d5b18807a",
"icons/apple-icon-114x114.png": "b5383cd5695e5767c81e91512e07c641",
"icons/apple-icon-120x120.png": "920dde0e170f5b36d7f2e5102f6e8eb8",
"icons/apple-icon-144x144.png": "954c712f4fa226797e83972093092ae5",
"icons/apple-icon-152x152.png": "cc70abb334fbc75e0180e9fc96bbf2c5",
"icons/apple-icon-180x180.png": "4aad398eb9cfff51fcd037a209a58ff8",
"icons/apple-icon-57x57.png": "b68dd0f08489631493995c61497b93e9",
"icons/apple-icon-60x60.png": "862e65b205770588dcdcebead35279ee",
"icons/apple-icon-72x72.png": "061893fc6c6fe9187e493d7cf3e339e5",
"icons/apple-icon-76x76.png": "ee2d87996bf504d9aea2d18fb6796a57",
"icons/apple-icon-precomposed.png": "404b7b863b92308d85a5296d67284b86",
"icons/apple-icon.png": "e0e07228404b20a9b1e8ddec04345859",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/favicon-16x16.png": "6cbcd3af6fe764bdd1d00be9a6402378",
"icons/favicon-32x32.png": "897fb2d37d22a7c19c426b7ae9bdc2b2",
"icons/favicon-96x96.png": "05027220a444f0731775b2357f35e768",
"icons/favicon.ico": "de1236fe785aca6d00cf52edaf8d4319",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/manifest.json": "458d04767e2e39e9c54752d737300f05",
"icons/ms-icon-144x144.png": "a2a4dbf623312d63794d8d3d2ce30ab6",
"icons/ms-icon-150x150.png": "b513813a0dbba116f7d65daef4a0a9fe",
"icons/ms-icon-310x310.png": "07d7ad0bde3bc991f6aadc68035b426b",
"icons/ms-icon-70x70.png": "4900f2740ecb7e8f7f3711623ccc4072",
"index.html": "7216041e5bef74dcaa486cb6e7e63396",
"/": "7216041e5bef74dcaa486cb6e7e63396",
"main.dart.js": "049adb023b121a97c23c0217190db67c",
"manifest.json": "4a5b0df4141319199c344c3c3fc45145",
"version.json": "589d5ab152fe449878c1619f59b3c14b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
