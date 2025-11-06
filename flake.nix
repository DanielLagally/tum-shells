{
  description = "Templates and devShells for courses at TUM";

  inputs = {
    flake-utils.url =  "github:numtide/flake-utils"; # TODO

    gbs = { url = "./gbs"; };
    it-sec = { url = "./it-sec"; };
    fpv = { url = "./fpv"; };
    eist = { url = "./eist"; };
  };

  outputs = { self, flake-utils, ... } @ inputs :
  let
    system = "x86_64-linux"; # don't fixiate this
    courses = {
      gbs = inputs.gbs;
      it-sec = inputs.it-sec;
      fpv = inputs.fpv;
      eist = inputs.eist;
    };

    build_templates = builtins.mapAttrs (name: value: {
      path = ./${name};
      description = "${name} template";
      welcomeText = "Please allow direnv by typing 'direnv allow'";
    });
    templates = build_templates courses;

    build_devShells = courses: {${system} = builtins.mapAttrs (name: value: courses.${name}.devShells.x86_64-linux.default) courses;};
    devShells = build_devShells courses;
  in
    {
      inherit templates;
      inherit devShells;
    };
}
